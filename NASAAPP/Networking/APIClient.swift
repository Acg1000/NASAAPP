//
//  ApiClient.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}

protocol APIClient {
    var session: URLSession { get }
    
    func fetch<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void, parse: @escaping (JSON) throws -> T?)
    func fetch<T: Decodable>(with request: URLRequest, completion: @escaping (Result<[T], APIError>) -> Void, parse: @escaping (JSON) throws -> [T])
}

extension APIClient {
    
    typealias JSON = Data
    typealias JSONTaskCompletionHandler = (Data?, APIError?) -> Void
    
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            // Depending on the status code...
            if httpResponse.statusCode == 200 {
                if let data = data {
                    
                    completion(data, nil)
                    
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
            
        }
        
        return task
    }
    
    func fetch<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void, parse: @escaping (JSON) throws -> T? ) {
        
        let task = jsonTask(with: request) { data, error in
            
                guard let data = data else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    
                    return
                }
                        
                
                do {
                    if let value = try parse(data) {
                        completion(Result.success(value))
                    }
                    
                } catch DecodingError.dataCorrupted(let context) {
                    print("Data Corrupted: context: \(context)")
                    completion(Result.failure(APIError.jsonConversionFailure))
                        
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("\n\(key) was not found with \(context) \n")
                    completion(Result.failure(APIError.jsonParsingFailure))
                    
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type Mismatch: type \(type), context \(context)")
                    completion(Result.failure(APIError.jsonConversionFailure))
                    
                } catch DecodingError.valueNotFound(let type, let context) {
                    print("Value Not Found: type \(type), context \(context)")
                    completion(Result.failure(APIError.jsonConversionFailure))
                    
                } catch {
                    print("Error with Decoded Character Results \(error)")
                    completion(Result.failure(APIError.jsonParsingFailure))
                  
                
            }
        }
        
        task.resume()
    }
    
    func fetch<T: Decodable>(with request: URLRequest, completion: @escaping (Result<[T], APIError>) -> Void, parse: @escaping (JSON) throws -> [T] ) {
        
        let task = jsonTask(with: request) { data, error in
            
                guard let data = data else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    
                    return
                }
                
                do {
                    // Trys to apply the decoder / parsing method to the JSON
                    let value = try parse(data)
                    
                    if !value.isEmpty {
                        completion(.success(value))
                    } else {
                        completion(.failure(.jsonParsingFailure))
                    }
                    
                    // Error catching
                } catch DecodingError.dataCorrupted {
                    completion(Result.failure(APIError.jsonConversionFailure))
                    
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("\n\(key) was not found with \(context) \n")
                    completion(Result.failure(APIError.jsonParsingFailure))
                    
                } catch DecodingError.typeMismatch {
                    completion(Result.failure(APIError.jsonConversionFailure))
                    
                } catch DecodingError.valueNotFound {
                    completion(Result.failure(APIError.jsonConversionFailure))
                    
                } catch {
                    print("Error with Decoded Character Results \(error)")
                    completion(Result.failure(APIError.jsonParsingFailure))
                  
                
            }
        }
        
        task.resume()

        
    }
}

