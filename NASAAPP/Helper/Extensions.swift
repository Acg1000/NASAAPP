//
//  Extensions.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/8/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static var dataDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
