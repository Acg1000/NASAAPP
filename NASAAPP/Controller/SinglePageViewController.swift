//
//  SinglePageViewController.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/2/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//
//  PURPOSE: Serves as the class representing a page on the page view controller

import UIKit

class SinglePageViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var swipeLabel: UILabel!
    
    var type: PageEnum!
    let roverAPIClient = NASAAPIClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView(type: type)

    }
    
    // Function that setsup the view depending on the type of page that it is
    func setupView(type: PageEnum) {
        switch type {
        case .roverPostcard:
            titleLabel.text = "Rover Postcard"
            descriptionLabel.text = "Chose from a plethora of photos taken from various rovers on the surface of mars to make and email yourself a postcard with that image"
            button.setTitle("Create Rover Postcard", for: .normal)
            imageView.image = #imageLiteral(resourceName: "RoverImage")
            swipeLabel.text = "Swipe for Earth Imagery ->"
            
        case .earthImagery:
            titleLabel.text = "Earth Imagery"
            descriptionLabel.text = "Scout areas on earth from a map and see am image from that location"
            button.setTitle("Scout Earth", for: .normal)
            imageView.image = #imageLiteral(resourceName: "EarthImage")
            swipeLabel.text = "<- Swipe for Rover Postcard"
            
        }
        navigationController?.navigationBar.isHidden = true
    }
    
    // Happens when the button at the bottom of the screen is pressed
    @IBAction func buttonPressed(_ sender: Any) {
        switch type {
        case .roverPostcard:
            let roverImageCollectionViewController = storyboard?.instantiateViewController(withIdentifier: "RoverImageCollectionViewController") as! RoverImageCollectionViewController
            
            navigationController?.pushViewController(roverImageCollectionViewController, animated: true)
            
        case .earthImagery:
            let earthImageryViewController = storyboard?.instantiateViewController(withIdentifier: "EarthImageryViewerController") as! EarthImageryViewController
            
            navigationController?.pushViewController(earthImageryViewController, animated: true)
            
        default:
            return
        }
    }
}
