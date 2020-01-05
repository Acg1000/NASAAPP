//
//  PendingOperations.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

class PendingOperations {
    var downloadsInProgress = [IndexPath: Operation]()
    
    let downloadQueue = OperationQueue()
}
