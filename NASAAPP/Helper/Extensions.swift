//
//  Extensions.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/8/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit

extension JSONDecoder {
    static var dataDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}


extension UIViewController {
    
    // Creates and presents an alert
    func alert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
