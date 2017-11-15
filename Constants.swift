//
//  Constants.swift
//  23andMe
//
//  Created by Kevin on 11/13/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import Foundation

struct Instagram {
    static let AuthURL = "https://api.instagram.com/oauth/authorize/"
    static let ApiURL  = "https://api.instagram.com/v1/users/"
    static let ClientID  = "0637825256de4d9e9c969ec594b032c8"
    static let RedirectURI = "https://www.23andme.com"
    static let AccessToken =  "access_token"
}

struct Images {
    static let emptyHeart = "heartEmpty"
    static let filledHeart = "heartFilled"
}

struct defaultKeys {
    static let accessToken = "accessToken"
}
