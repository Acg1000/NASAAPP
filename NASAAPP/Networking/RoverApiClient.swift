//
//  RoverApiClient.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

class RoverApiClient: APIClient {
    var session: URLSession
    private let APIKey = "5IQD9ugr2GM5cQgcUwDEdT2F13SBlCnYVmDCIfM3"
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    // get photos with a certain sol
    func getRoverPhotos(withSol sol: Int, completion: @escaping (Result<[RoverData], APIError>) -> Void)  {
        let endpoint = NasaEndpoints.getRoverPhotos(forSol: sol, apiKey: APIKey)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let request = endpoint.request
        print(request)
        
        fetch(with: request, completion: completion) { data -> [RoverData] in
            let roverData = try decoder.decode([String: [RoverData]].self, from: data)
            guard let results = roverData["photos"] else { return [] }
            
            return results
        }
    }
}
