//
//  RoverEndpoint.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    // Returns an instance of URLComponents containing the base URL, path and query items provided
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        
        return components
    }
    
    // Returns an instance of URLRequest encapsulating the endpoint URL. This URL is obtained through the `urlComponents` object.
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}




enum NasaEndpoints {
    
    // Creates the endpoints useable for calling the API
    case getRoverPhotos(forSol: Int, apiKey: String)
}


extension NasaEndpoints: Endpoint {
    var base: String {
        return "https://api.nasa.gov"
    }
    
    var path: String {
        switch self {
        case .getRoverPhotos: return "/mars-photos/api/v1/rovers/curiosity/photos"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getRoverPhotos(let sol, let apiKey):
            return [
                URLQueryItem(name: "sol", value: String(sol)),
                URLQueryItem(name: "api_key", value: apiKey)]
        }
    }
}
