//
//  RoverImageCollectionViewController.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit

private let reuseIdentifier = "roverImageCell"

class RoverImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var roverPhotos: [RoverPhoto] = [] {
        didSet {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
                
            }
        }
    }

    let roverAPIClient = NASAAPIClient()
    let pendingOperations = PendingOperations()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        loadRoverData()
        
    }
    
    // MARK: Helper Methods
    
    // Loads the rover data from the API
    func loadRoverData() {
        roverAPIClient.getRoverPhotos(withSol: 1000) { result in
            switch result {
            case .success(let data):
                self.roverPhotos = data
                
            case .failure(let error):
                self.activityIndicator.stopAnimating()

                switch error {
                case .invalidData:
                    self.alert(withTitle: "Invalid Data", andMessage: "There was a problem with data processing. Make sure you have a stable internet connection")
                    
                case .jsonConversionFailure, .jsonParsingFailure:
                    // I want the app to crash if there was a conversion failure
                    fatalError("Json conversion error: \(error)")
                    
                case .requestFailed, .responseUnsuccessful, .networkerError:
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)

                        self.alert(withTitle: "Request/Response Failed", andMessage: "Please check your internet connection... There was s problem retreving information from the internet...")
                    }
                }
            }
        }
    }
    
    // Creates and presents an alert
    func alert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roverPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoverImageCell
        let currentPhoto = roverPhotos[indexPath.row]
        
        cell.configureCell(withPhoto: currentPhoto)
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postcardFormatterViewController = storyboard?.instantiateViewController(identifier: "PostcardFormatterViewController") as! PostcardFormatterViewController
        postcardFormatterViewController.photo = roverPhotos[indexPath.row]
        navigationController?.pushViewController(postcardFormatterViewController, animated: true)
    }
    
    
    // MARK: FLOW LAYOUT
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return .init(width: 150, height: 150)
//    }
        
}
