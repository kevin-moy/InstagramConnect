//
//  LoginViewController.swift
//  23andMe
//
//  Created by Kevin on 11/13/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        webView.navigationDelegate = self
        
        let url = URL(string: "\(Instagram.AuthURL)?client_id=\(Instagram.ClientID)&redirect_uri=\(Instagram.RedirectURI)&response_type=token")
        
        webView.frame = view.bounds
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
        
        let myRequest = URLRequest(url: url!)
        webView.load(myRequest)
        view.addSubview(webView)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let url = navigationResponse.response.url, let host = url.host, host.hasPrefix("www.23andme.com") {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageVC") as? ImageViewController
            {
                if let range = url.absoluteString.range(of: "access_token=") {
                    let accessToken = String(url.absoluteString.suffix(from: range.upperBound))
                    vc.defaults.set(accessToken, forKey: defaultKeys.accessToken)
                }
                present(vc, animated: true, completion: nil)
            }
            decisionHandler(.cancel)
        }
        else {
            decisionHandler(.cancel)
        }
    }
    
    // Username: mobile23_tester4
    //■ Password: 23mobileTester23
    // https://api.instagram.com/v1/users/self/media/recent/?access_token=ACCESS-TOKEN
    //https://stackoverflow.com/questions/36231061/wkwebview-open-links-from-certain-domain-in-safari
    //https://developer.apple.com/documentation/webkit/wknavigationaction
    //https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
}

