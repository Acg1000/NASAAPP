//
//  RoverImageCell.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/4/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit

class RoverImageCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: RoverImageCell.self)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    
    func configureCell(withPhoto data: RoverPhoto) {
        label.text = data.earthDate
        topLabel.isHidden = true
//        topLabel.text = data.
        
        if let image = data.image {
            let scale = 150 / image.size.width
            let newHeight = image.size.height * scale
            
            // TODO, IF THE NEW HEIGHT IS LESS THEN A CERTAIN AMOUNT, DELETE THE IMAGE
            
            UIGraphicsBeginImageContext(CGSize(width: 150, height: newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width: 150, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            imageView.image = newImage

        }
    }
}
