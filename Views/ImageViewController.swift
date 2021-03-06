//
//  ImageViewController.swift
//  23andMe
//
//  Created by Kevin on 11/13/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class ImageViewController: UITableViewController {

    var imageFeed = ImageViewModel()
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImagesForUser()
    }
    
    func getImagesForUser() {
        imageFeed.feedRequest(defaults.string(forKey: defaultKeys.accessToken)) { (success, _, error) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            else if error != nil {
                self.noConnectionAlert()
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        let logOutAction = UIAlertAction(title: "Logout", style: .default) { (action) in
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
            {
                self.present(vc, animated: true, completion: nil)
           }
        }
        alert.addAction(logOutAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func noConnectionAlert() {
        let alertController = UIAlertController.init(title: "Error", message: "No Internet connection. Please try again", preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func heartPressedSuccessful(_ mediaID: String!, isLiked: Bool) -> Bool {
        var isSuccess: Bool = false
        ApiManager.sharedInstance.changeLikeStatus(defaults.string(forKey: defaultKeys.accessToken), mediaID: mediaID, isLiked: isLiked) { (success, error) in
            if success {
                isSuccess = true
            }
            if error != nil {
                let alert = UIAlertController.init(title: "Error", message: error, preferredStyle: .alert)
                let okayAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okayAction)
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                isSuccess = false
            }
        }
        if isSuccess {
            return true
        }
        else {
            return false
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ImageCell
        cell.setupCell(image: self.imageFeed.images[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageFeed.images.count
    }
    
}
