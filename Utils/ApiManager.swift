//
//  ApiManager.swift
//  23andMe
//
//  Created by Kevin on 11/13/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import Foundation

class ApiManager {
    static let sharedInstance = ApiManager()
    func getImages(_ accessToken: String!, completionHandler:@escaping (_ assignments: [ImageObject]?, _ error: String?) -> Void) {
        
        let group = DispatchGroup()
        var imageArray = [ImageObject]()
        let url = URL(string: "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(accessToken!)")!

        group.enter()
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                print(error!)
                completionHandler(nil, error as! String?)
                return
            }
            guard data != nil else {
                print("Data is empty")
                return
            }
            
            if error != nil {
                print("Error fetching photos: \(String(describing: error))")
                return
            }
            
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                
                guard let instagramDictionary = dictionary!["data"] as? [[String: Any]] else {
                    return
                }
                for feedData in instagramDictionary {
                    let feed = ImageObject.init(json: feedData)
                    imageArray.append(feed)
                }
                completionHandler(imageArray, nil)
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                return
            }
        })
        task.resume()
        group.notify(queue: .main) {
            completionHandler(imageArray, nil)
        }
    }
    
    func changeLikeStatus(_ accessToken: String!, mediaID: String!, isLiked: Bool!, completionHandler:@escaping (_ succeed: Bool, _ error: String?) -> Void) {
        
        let url = URL(string: "https://api.instagram.com/v1/media/\(mediaID!)/likes?access_token=\((accessToken!))")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if isLiked {
            request.httpMethod = "DELETE"
        }
        else {
            request.httpMethod = "POST"
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for networking error
            guard let data = data, error == nil else {
                completionHandler(false, String(describing: error))
                return
            }
            // Check for http errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            let response = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let meta = response["meta"] as! [String: Any]
            if let errorString = meta["error_message"]{
                completionHandler(false, String(describing: errorString))
            }
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
        completionHandler(true, nil)
    }
}
