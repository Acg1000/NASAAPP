//
//  PostcardFormatterViewController.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/5/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class PostcardFormatterViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var roverLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postcardTextLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var photo: RoverPhoto!
    
    override func viewDidLoad() {
        imageView.image = photo.image
        roverLabel.text = photo.rover.name
        dateLabel.text = photo.earthDate
        cameraLabel.text = photo.camera.name
        
    }
    
    func createPostcard() {
        let textColor = UIColor.label
        let textFont = UIFont.systemFont(ofSize: 70)
        let shadowColor = UIColor.systemBackground
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(imageView.image?.size ?? CGSize(width: 150, height: 150), false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
//            NSAttributedString.Key.shadow: shadowColor,
        ] as [NSAttributedString.Key: Any]
        
        if let photo = photo.image {
            photo.draw(in: CGRect(x: 0, y: 0, width: photo.size.width, height: photo.size.height))
            
            let rect = CGRect(origin: CGPoint(x: 25, y: photo.size.height-275), size: photo.size)
//            let text: String = "\(roverLabel)\n\(cameraLabel)\n\(dateLabel)"
            let text = "epic\ngamer\nmoment"
            
            text.draw(in: rect, withAttributes: textFontAttributes)
            
//
//            let textToDraw: NSString = "\(roverLabel)\n\(cameraLabel)\n\(dateLabel)" as NSString
//
//            textToDraw.draw(in: rect, withAttributes: textFontAttributes)
            
            
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            imageView.image = newImage
            roverLabel.isHidden = true
            cameraLabel.isHidden = true
            dateLabel.isHidden = true
            print("image replaced")
            
        } else {
            //TODO: Handle the error properly
            UIGraphicsEndImageContext()
            print("image not present")

        }
    }
    
    @IBAction func textFieldContentChanged(_ sender: Any) {
        postcardTextLabel.text = textField.text
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        createPostcard()
    }
}

extension PostcardFormatterViewController: MFMailComposeViewControllerDelegate {
    
    func sendMail(imageView: UIImageView) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["andrewcgraves@gmail.com"])
            mail.setSubject("Postcard From NASA App")
            mail.setMessageBody("A postcard has been sent to you from NASAAPP! It is attached to this email as a photo", isHTML: false)
            
//            let imageData:
        }
    }
}
