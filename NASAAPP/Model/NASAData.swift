//
//  NASAData.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit

enum ImageState {
    case placeholder
    case downloaded
    case failed
}

protocol NASAData: Decodable {
    var image: UIImage? { get set }
    var imageState: ImageState { get set }
    var imgSrc: URL { get }
}
