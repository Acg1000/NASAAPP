//
//  EarthImage.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/6/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit

class EarthImage: NASAData {
    let cloudScore: Double
    let date: Date
    var imgSrc: URL
    
    var image: UIImage? = nil
    var imageState = ImageState.placeholder
    
    enum CodingKeys: String, CodingKey {
        case cloudScore, date, imgSrc = "url"
    }
    
    init() {
        self.cloudScore = 0
        self.date = Date()
        self.imgSrc = URL(string: "")!
    }
}
