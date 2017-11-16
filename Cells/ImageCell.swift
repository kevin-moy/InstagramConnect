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
    var cellData = ImageObject()
    var defaults = UserDefaults.standard
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
        likeCount.text =  String(describing:image.likeCount!)
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
        // Update UI
        if self.isLiked {
            self.setButtonOff()
        } else {
            self.setButtonOn()
        }
        ApiManager.sharedInstance.changeLikeStatus(defaults.string(forKey: defaultKeys.accessToken), mediaID: cellData.mediaID, isLiked: isLiked) { (success, error) in
            if success {
            }
            if error != nil {
                // If unsuccessful reset UI
                DispatchQueue.main.async {
                    if self.isLiked {
                        self.setButtonOff()
                    } else {
                        self.setButtonOn()
                    }
                }
                let alert = UIAlertController.init(title: "Error", message: error, preferredStyle: .alert)
                let okayAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okayAction)
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setButtonOn() {
        isLiked = true
        cellData.likeCount = cellData.likeCount!+1
        likeCount.text = String(describing:cellData.likeCount!)
        likeButton.setImage( onImage, for: UIControlState() )
        likeButton.setImage( onImage, for: .selected )
    }

    func setButtonOff() {
        isLiked = false
        cellData.likeCount = cellData.likeCount!-1
        likeCount.text = String(describing:cellData.likeCount!)
        likeButton.setImage( offImage, for: UIControlState() )
        likeButton.setImage( offImage, for: .selected )
    }
}
