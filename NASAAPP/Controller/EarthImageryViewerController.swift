//
//  EarthImageryViewerController.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/6/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class EarthImageryViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    // Managers / Clients
    lazy var locationManager: LocationManager = {
        return LocationManager(locationDelegate: self, permissionsDelegate: nil)
    }()
    let apiClient = NASAAPIClient()
    
    // Variables
    var earthImage: EarthImage!
    var clLocation: CLLocation? = nil {
        didSet {
            if let clLocation = clLocation {
                print("Location was set")
                goToLocation(clLocation)
                getEarthImageData(ofLocation: clLocation)
            }
        }
    }
    var placemark: CLPlacemark? = nil {
        didSet {
            if let placemark = placemark {
                print("placemark was set")
                populateViewWithPlacemark(placemark)

            }
        }
    }
    
    
    
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup
        mapView.showsUserLocation = true
        locationField.delegate = self
        navigationController?.navigationBar.isHidden = false
        
        // Keyboard notification manager
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    // MARK: Helper Functions
    // Creates alert
    func alert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
        locationManager.requestLocation()
        currentLocationButton.tintColor = .systemBlue
    }
    
    func getEarthImageData(ofLocation location: CLLocation) {
        apiClient.getEarthImage(atLatitude: location.coordinate.latitude, andLongitude: location.coordinate.longitude) { result in
            switch result {
            case .success(let image):
                let imageData = (try? Data(contentsOf: image.imgSrc)) ?? Data()
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
                
            case .failure(let error):
                self.alert(withTitle: "Image Not Found", andMessage: "There was no image for this location...")
                print(error)
            }
        }
    }
    
    // These two functions allow the keyboard to push the view upwards
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
                // MARK: Location
    
    // Shifts the map to a provided location
    func goToLocation(_ location: CLLocation) {
        // create a center and region
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        // Set the map region and overlays
        mapView.setRegion(region, animated: true)
        mapView.removeOverlays(mapView.overlays)
        
    }
    
    func populateViewWithPlacemark(_ placemark: CLPlacemark) {
        if let name = placemark.name, let locality = placemark.locality {
            locationField.text = "\(name), \(locality)"

        }
    }
    
    @IBAction func mapPressed(_ sender: UIGestureRecognizer) {
        // Remove the annotations that exist
        mapView.removeAnnotations(mapView.annotations)
        
        // get the point where the user touched and turn it into a set of coordinates
        let touchPoint = sender.location(in: self.mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        let point = MKPointAnnotation()
        point.coordinate = touchMapCoordinate
        
        // Set the location for the class
        clLocation = CLLocation(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
        
        locationManager.getPlacemark(from: CLLocation(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)) { placemark in
            
            // Set the pin details
            point.title = placemark?.name
            point.subtitle = placemark?.locality
            
            // Set the placemark
            self.placemark = placemark
            
        }
        
        // Add the annotation
        mapView.addAnnotation(point)
        currentLocationButton.tintColor = .gray

    }
    
    func addPin(at location: CLLocation) {
        // Remove all the current annotations
        mapView.removeAnnotations(mapView.annotations)

        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        locationManager.getPlacemark(from: CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { placemark in
            
            // Set the pin details
            point.title = placemark?.name
            point.subtitle = placemark?.locality
            
            // Set the placemark
            self.placemark = placemark
        }
        
        // Add the annotation
        mapView.addAnnotation(point)
        currentLocationButton.tintColor = .gray
    }
}




// MARK: Extensions

extension EarthImageryViewController: LocationManagerDelegate {
    
    func obtainedPlacemark(_ placemark: CLPlacemark, location: CLLocation) {
        clLocation = location
        self.placemark = placemark
    }
    
    func failedWithError(_ error: LocationError) {
        switch error {
        case .disallowedByUser:
            alert(withTitle: "Location Access Needed", andMessage: "Please allow access to the location data to use this feature")

        case .unableToFindLocation:
            alert(withTitle: "Unable to Find Location", andMessage: "Somthing went wrong with the retrevial of your location...")
            
        case .unknownError:
            alert(withTitle: "Unknown Error", andMessage: "There was an unknown error...")
        }
    }
}

// Make keyboard dismiss when done is pressed on the keyboard
extension EarthImageryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        if let address = textField.text {
            locationManager.getLocation(from: address) { placemark in
                
                if let placemark = placemark, let location = placemark.location {
                    self.clLocation = location
                    self.placemark = placemark
                    self.addPin(at: location)

                } else {
                    textField.text = nil
                    textField.placeholder = "Location not found..."
                }
            }
        }
        
        return true
    }
}
