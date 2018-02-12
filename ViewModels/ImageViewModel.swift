//
//  ImageViewModel.swift
//  23andMe
//
//  Created by Kevin on 11/13/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import Foundation

class ImageViewModel {
    var images = [ImageObject]()
    
    func feedRequest(_ accessToken: String!, completionHandler:@escaping (_ succeed: Bool, _ total: Int?, _ error: String?) -> Void) {
        ApiManager.sharedInstance.getImages(accessToken!) { (images, error) in
            if let fetchedImages = images {
                self.images.append(contentsOf: fetchedImages)
                completionHandler(true, fetchedImages.count, nil)
            }
            else {
                completionHandler(false, nil, error)
            }
        }
    }
}
