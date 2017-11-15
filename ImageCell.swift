//
//  ImageCell.swift
//  23andMe
//
//  Created by Kevin on 11/14/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
class ImageCell: UITableViewCell {
    var isLiked = false
    var likeTotal: Int = 0
    var cellData = ImageObject()
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    
    @IBInspectable var onImage : UIImage!
    @IBInspectable var offImage : UIImage!

    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setupButton()
    }
    
    func setupButton() {
        offImage = UIImage(named:Images.emptyHeart)
        onImage = UIImage(named:Images.filledHeart)
    }
    
    func setupCell(image: ImageObject) {
        cellData = image
        likeTotal = image.likeCount!
        likeCount.text =  String(describing:likeTotal)
        isLiked = image.hasLiked!
        likeButton.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)
        if isLiked {
            likeButton.setImage( onImage, for: UIControlState() )
        }
        else {
            likeButton.setImage( offImage, for: UIControlState() )
        }
 
        let imageURL = URL(string: image.imageURLString!)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL!)
            DispatchQueue.main.async {
                self.contentImage.image = UIImage(data: data!)
            }
        }
    }
    @objc func buttonPressed(sender: UIButton!) {
        ImageViewController().heartPressed(cellData.mediaID, isLiked: cellData.hasLiked!)
        if isLiked {
            setButtonOff()
        } else {
            setButtonOn()
        }
    }
    func setButtonOn() {
        isLiked = true
        likeTotal = likeTotal + 1
        likeCount.text = String(describing:likeTotal)
        likeButton.setImage( onImage, for: UIControlState() )
        likeButton.setImage( onImage, for: .selected )
        self.layer.borderWidth = 2.0
    }

    func setButtonOff() {
        isLiked = false
        likeTotal = likeTotal - 1
        likeCount.text = String(describing:likeTotal)
        likeButton.setImage( offImage, for: UIControlState() )
        likeButton.setImage( offImage, for: .selected )
        self.layer.borderWidth = 0.0
    }
}
