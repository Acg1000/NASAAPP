//
//  PostcardFormatterViewController.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/5/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit

class PostcardFormatterViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var roverLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postcardTextLabel: UILabel!
    
    var photo: RoverPhoto!
    
    override func viewDidLoad() {
        imageView.image = photo.image
        roverLabel.text = photo.rover.name
        dateLabel.text = photo.earthDate
        cameraLabel.text = photo.camera.name
    }
}
