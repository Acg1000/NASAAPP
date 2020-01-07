//
//  SinglePageViewController.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/2/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit

class SinglePageViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var type: PageEnum!
    let roverAPIClient = NASAAPIClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView(type: type)
//        roverAPIClient.getRoverPhotos(withSol: 1000) { result in
//
//            switch result {
//            case .success(let data):
//                for item in data {
//                    print(item.id)
//                    print(item.imgSrc)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    func setupView(type: PageEnum) {
        switch type {
        case .roverPostcard:
            titleLabel.text = "Rover Postcard"
            descriptionLabel.text = "Chose from a plethora of photos taken from various rovers on the surface of mars to make and email yourself a postcard with that image"
            button.setTitle("Create Rover Postcard", for: .normal)
            
        case .earthImagery:
            titleLabel.text = "Earth Imagery"
            descriptionLabel.text = "Scout areas on earth from a map and see am image from that location"
            button.setTitle("Scout Earth", for: .normal)
            
        }
        navigationController?.navigationBar.isHidden = true
    }
    
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
