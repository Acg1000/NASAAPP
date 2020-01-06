//
//  RoverImageCollectionViewController.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "roverImageCell"

class RoverImageCollectionViewController: UICollectionViewController {
    
    var roverPhotos: [RoverPhoto] = [] {
        didSet {
            print("Updating photos")
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    let roverAPIClient = NASAAPIClient()
    let pendingOperations = PendingOperations()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        loadRoverData()
        
        
        
    }
    
    func loadRoverData() {
        roverAPIClient.getRoverPhotos(withSol: 1000) { result in
            
            switch result {
            case .success(let data):
                self.roverPhotos = data
                print("data revieved :)")
            case .failure(let error):
                // TODO: Fail more gracefully
                fatalError("\(error)")
            }
        }
    }
    
    func downloadRoverImages(forPhoto photo: RoverPhoto, atIndexPath indexPath: IndexPath) {
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ImageDownloader(nasaData: photo)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                print("Artwork Download Finished!")
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roverPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roverImageCell", for: indexPath) as! RoverImageCell
        let currentPhoto = roverPhotos[indexPath.row]
        
        cell.configureCell(withPhoto: currentPhoto)
        
        if currentPhoto.imageState == .placeholder {
            downloadRoverImages(forPhoto: currentPhoto, atIndexPath: indexPath)
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postcardFormatterViewController = storyboard?.instantiateViewController(identifier: "PostcardFormatterViewController") as! PostcardFormatterViewController
        postcardFormatterViewController.photo = roverPhotos[indexPath.row]
        navigationController?.pushViewController(postcardFormatterViewController, animated: true)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//        print("item tapped")
//
//    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

 */
}
