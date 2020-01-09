//
//  RoverImageCell.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit

class RoverImageCell: UICollectionViewCell {
    static let reuseIdentifier = "roverImageCell"

    var imageDownloader: ImageDownloader!
    let operationQueue = OperationQueue()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    
    func configureCell(withPhoto data: RoverPhoto) {
            label.text = data.earthDate
            topLabel.isHidden = true
            
            let imageDownloader = ImageDownloader(url: data.imgSrc)
            imageDownloader.completionBlock = {
                DispatchQueue.main.async {
                    
                    guard let image = imageDownloader.image else { return }
                    
                    let scale = 150 / image.size.width
                    let newHeight = image.size.height * scale
                                        
                    UIGraphicsBeginImageContext(CGSize(width: 150, height: newHeight))
                    image.draw(in: CGRect(x: 0, y: 0, width: 150, height: newHeight))
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    self.imageView.image = newImage
                }
            }
            
            operationQueue.addOperation(imageDownloader)
    }
    
    override func prepareForReuse() {
        imageView.image = #imageLiteral(resourceName: "PlaceholderImage")
        
        imageDownloader.cancel()
    }
}
