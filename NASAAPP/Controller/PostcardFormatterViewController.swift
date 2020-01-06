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
        postcardTextLabel.sizeToFit()
        
        // Set delegates for the fields so they dismiss when the return key is pressed
        textField.delegate = self
        emailField.delegate = self
        
        // Keyboard notification manager
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: Helper Functions
    
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
            
            // These rectangles set the bounds for drawing the text over the image
            let metaDataRect = CGRect(origin: CGPoint(x: 25, y: photo.size.height-275), size: photo.size)
            let messageRect = CGRect(origin: CGPoint(x: 25, y: 0), size: photo.size)
            
            // Setting and drawing the text on the image
            let metaDataText = "\(self.photo.rover.name)\n\(self.photo.camera.name)\n\(self.photo.earthDate)"
            metaDataText.draw(in: metaDataRect, withAttributes: textFontAttributes)

            if let message = textField.text {
                message.draw(in: messageRect, withAttributes: textFontAttributes)
            }
            
            // get the new image from the context in which we've been working
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Hide all the views: TESTING
            imageView.image = newImage
            roverLabel.isHidden = true
            cameraLabel.isHidden = true
            dateLabel.isHidden = true
            postcardTextLabel.isHidden = true
            
        } else {
            //TODO: Handle the error properly
            UIGraphicsEndImageContext()
            print("image not present")

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
    
    
    // MARK: Outlet Functions
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



// MARK: Extensions

// Make keyboard dismiss when done is pressed on the keyboard
extension PostcardFormatterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
}
