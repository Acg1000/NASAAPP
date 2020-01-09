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
        
        // Make a network call asking for the image
        Networker.request(url: URLRequest(url: https)) { result in
            do {
                let imageData = try result.get()
                
                if self.isCancelled {
                    return
                }
                
                if imageData.count > 0 {
                    self.nasaData.image = UIImage(data: imageData)
                    self.nasaData.imageState = .downloaded
                    
                } else {
                    self.nasaData.imageState = .failed
                }
                
            } catch {
                self.nasaData.imageState = .failed
            }
        }
    }
}
