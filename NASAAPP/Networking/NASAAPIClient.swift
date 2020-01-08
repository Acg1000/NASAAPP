//
//  RoverApiClient.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

class NASAAPIClient: APIClient {
    var session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    // get photos with a certain sol
    func getRoverPhotos(withSol sol: Int, completion: @escaping (Result<[RoverPhoto], APIError>) -> Void)  {
        let endpoint = NasaEndpoints.getRoverPhotos(forSol: sol)
        
        let decoder = JSONDecoder.dataDecoder
        // TODO Format the date

        let request = endpoint.request
        
        fetch(with: request, completion: completion) { data -> [RoverPhoto] in
            let roverData = try decoder.decode([String: [RoverPhoto]].self, from: data)
            guard let results = roverData["photos"] else { return [] }
            
            return results
        }
    }
    
    func getEarthImage(atLatitude latitude: Double, andLongitude longitude: Double, completion: @escaping (Result<EarthImage, APIError>) -> Void) {
        let endpoint = NasaEndpoints.getEarthImage(atLatitude: latitude, andLongitude: longitude)
        
        let decoder = JSONDecoder.dataDecoder
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let request = endpoint.request
        
        fetch(with: request, completion: completion) { data -> EarthImage in
            let earthImageData = try decoder.decode(EarthImage.self, from: data)
            
            return earthImageData
        }
    }
}
