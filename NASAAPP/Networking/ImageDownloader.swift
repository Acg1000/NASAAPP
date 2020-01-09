//
//  ImageDownloader.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit

class AsyncOperation: Operation {
    enum State: String {
        case ready, finished, executing
        
        fileprivate var keyPath: String {
            return "is\(rawValue.capitalized)"
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        main()
        state = .executing
    }
}

class ImageDownloader: AsyncOperation {
    var image: UIImage?
    let url: URL
        
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
                
        // Adding HTTPS to replace the http
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        comps.scheme = "https"
        let https = comps.url!
        
        // Make a network call asking for the image
        Networker.request(url: URLRequest(url: https)) { result in
            defer { self.state = .finished }
            do {
                let imageData = try result.get()
                
                if self.isCancelled {
                    return
                }
                
                self.image = UIImage(data: imageData)

            } catch {
                self.state = .finished
            }
        }
    }
}
