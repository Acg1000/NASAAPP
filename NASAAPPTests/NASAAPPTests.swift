//
//  NASAAPPTests.swift
//  NASAAPPTests
//
//  Created by Andrew Graves on 1/6/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import XCTest
@testable import NASAAPP

class NASAAPPTests: XCTestCase {
    var apiClient: NASAAPIClient!
    var session: URLSession!

    override func setUp() {
        apiClient = NASAAPIClient()
        session = URLSession(configuration: .default)
        super.setUp()

    }

    override func tearDown() {
        apiClient = nil
        super.tearDown()

    }
    
    // MARK: URLTests
    
    // Mars rover API test
    func testMarsURL() {
        let endpoint = NasaEndpoints.getRoverPhotos(forSol: 1000).urlComponents.url!
        let expectedURL = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=5IQD9ugr2GM5cQgcUwDEdT2F13SBlCnYVmDCIfM3")
        
        XCTAssertEqual(endpoint, expectedURL)
    }
    
    func testEarthImageryURL() {
        let endpoint = NasaEndpoints.getEarthImage(atLatitude: 1.5, andLongitude: 100.75).urlComponents.url!
        let expectedURL = URL(string: "https://api.nasa.gov/planetary/earth/imagery/?lon=100.75&lat=1.5&cloud_score=True&api_key=5IQD9ugr2GM5cQgcUwDEdT2F13SBlCnYVmDCIfM3")
               
        XCTAssertEqual(endpoint, expectedURL)
    }
    
    
    // MARK: Testing API
    
    func testMarsAPI() {
        let expectation = self.expectation(description: "Status OK")
        let testEndpoint = NasaEndpoints.getRoverPhotos(forSol: 1000)
        var statusCode: Int?
        var responseError: Error?
        
        session.dataTask(with: testEndpoint.urlComponents.url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            expectation.fulfill()
        }.resume()
        
        waitForExpectations(timeout: 4, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
        
    }
    
    func testEarthImageryAPI() {
        let expectation = self.expectation(description: "Status OK")
        let testEndpoint = NasaEndpoints.getEarthImage(atLatitude: 1.5, andLongitude: 100.75)
        var statusCode: Int?
        var responseError: Error?
        
        session.dataTask(with: testEndpoint.urlComponents.url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            expectation.fulfill()
        }.resume()
        
        waitForExpectations(timeout: 4, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
    // MARK: Decoding Tests
    
    func testMarsApiDecoding() {
        let expectation = self.expectation(description: "Status OK")
        var recievedPhotos: [RoverPhoto]?
        var recievedError: Error?
        
        apiClient.getRoverPhotos(withSol: 100) { result in
            switch result {
            case .success(let photos):
                recievedPhotos = photos
                
            case .failure(let error):
                recievedError = error
            }
            
            expectation.fulfill()
            
        }
        waitForExpectations(timeout: 4, handler: nil)
        XCTAssertNil(recievedError)
        XCTAssertNotNil(recievedPhotos)
    }
    
    
    func testEarthImageAPIDecoding() {
        let expectation = self.expectation(description: "Status OK")
        var recievedImage: EarthImage?
        var recievedError: Error?
        
        apiClient.getEarthImage(atLatitude: 1.5, andLongitude: 100.75) { result in
            switch result {
            case .success(let image):
                recievedImage = image
                
            case .failure(let error):
                recievedError = error
            }
            
            expectation.fulfill()
            
        }
        waitForExpectations(timeout: 4, handler: nil)
        XCTAssertNil(recievedError)
        XCTAssertNotNil(recievedImage)
        
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
