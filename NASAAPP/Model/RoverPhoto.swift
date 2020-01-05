//
//  RoverData.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/2/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit

class RoverPhoto: NASAData {
    let id: Int
    let imgSrc: URL
    let earthDate: String
    let camera: RoverCamera
    let rover: Rover
    
    var image: UIImage? = nil
    var imageState = ImageState.placeholder
    
    init() {
        self.id = 0
        self.imgSrc = URL(string: "")!
        self.earthDate = ""
        self.camera = RoverCamera(name: "")
        self.rover = Rover(name: "")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case imgSrc
        case earthDate
        case camera
        case rover
    }
}

struct RoverCamera: Decodable {
    let name: String
}

struct Rover: Decodable {
    let name: String
}

//extension RoverData {
//    var image: UIImage = {
//
//    }
//}
