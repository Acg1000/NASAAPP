//
//  ImageDownloader.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader: Operation {
    
    var nasaData: NASAData
    
    init(nasaData: NASAData) {
        self.nasaData = nasaData
        super.init()
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        let imageURL = nasaData.imgSrc
        
        // Adding HTTPS to replace the http
        var comps = URLComponents(url: imageURL, resolvingAgainstBaseURL: false)!
        comps.scheme = "https"
        let https = comps.url!
        
        let imageData = try! Data(contentsOf: https)
        
        if self.isCancelled {
            return
        }
        
        if imageData.count > 0 {
            nasaData.image = UIImage(data: imageData)
            nasaData.imageState = .downloaded
            
        } else {
            nasaData.imageState = .failed
        }
    }
}
