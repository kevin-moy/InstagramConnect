//
//  ImageObject.swift
//  23andMe
//
//  Created by Kevin on 11/13/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import Foundation

class ImageObject {
    
    var likeCount: Int?
    var hasLiked: Bool?
    var imageURLString: String?
    var mediaID: String?
    convenience init(json: [String: Any]) {
        self.init()
    
        if let id = json["id"] {
            mediaID = id as? String
        }
        
        if let imageLikeCount = json["likes"] as? [String: AnyObject] {
            likeCount = imageLikeCount["count"] as? Int
        }
        if let imageHasLiked = json["user_has_liked"] {
            hasLiked = imageHasLiked as? Bool
        }
        
        guard let imageJSON = json["images"] as? [String: AnyObject]  else {
            return
        }
        if let imageInfo = imageJSON["standard_resolution"] as? [String: AnyObject] {
            imageURLString = imageInfo["url"] as? String
        }
        
        
    }
}
