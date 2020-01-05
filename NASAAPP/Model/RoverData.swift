//
//  RoverData.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/2/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit

class RoverData: Decodable {
    let id: Int
//    let imageURL: String
    let imgSrc: URL
    let earthDate: String
    
    init() {
        self.id = 0
//        self.imageURL = ""
        self.imgSrc = URL(string: "")!
        self.earthDate = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case imgSrc
//        case imageURL = "img_src"
        case earthDate
    }
}

//extension RoverData {
//    var image: UIImage = {
//
//    }
//}
