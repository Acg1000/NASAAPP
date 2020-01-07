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
        super.viewDidLoad()
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
    
    // Draws from the textfield the information from the photo to create a postcard attachment ready to send through mail
    func createPostcard() -> UIImage? {
        let textColor = UIColor.label
        let textFont = UIFont.systemFont(ofSize: 70)
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(imageView.image?.size ?? CGSize(width: 150, height: 150), false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor
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
            return newImage
            
        } else {
            UIGraphicsEndImageContext()
            return nil
        }
    }
    
    func alert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
        guard let postcard = createPostcard(), let email = emailField.text else {
            alert(withTitle: "Invalid Selection / Email", andMessage: "Please make sure you have an email entered and a picture selected")
            return
        }
        
        sendMail(image: postcard, withRecipient: email)
    }
}


// MARK: Extensions

// Adds implementation for mailing the artwork
extension PostcardFormatterViewController: MFMailComposeViewControllerDelegate {
    
    func sendMail(image: UIImage, withRecipient recipient: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipient])
            mail.setSubject("Postcard From NASA App")
            mail.setMessageBody("A postcard has been sent to you from NASAAPP! It is attached to this email as a photo", isHTML: false)
            
            if let imageData = image.jpegData(compressionQuality: 1) {
                mail.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "rover-postcard")
            }
            
            self.present(mail, animated: true, completion: nil)
        } else {
            
            alert(withTitle: "Mail Not Setup", andMessage: "Your phone is not currently setup to send mail. Add a mailing client through your mail app to send mail in this app")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("Result code from email: \(result)")
        controller.dismiss(animated: true, completion: nil)
    }
}

// Make keyboard dismiss when done is pressed on the keyboard
extension PostcardFormatterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
}
