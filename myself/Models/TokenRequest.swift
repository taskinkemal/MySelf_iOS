//
//  TokenRequest.swift
//  myself
//
//  Created by Kemal Taskin on 01.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation

class TokenRequest : BaseModel
{
    var Email: String
    var FirstName: String
    var LastName: String
    var PictureUrl: String
    var FacebookToken: String
    var GoogleToken: String
    var DeviceID: String
    
    init(Email: String, FirstName: String, LastName: String,
         PictureUrl: String, FacebookToken: String, GoogleToken: String,
         DeviceID: String)
    {
        self.Email = Email;
        self.FirstName = FirstName;
        self.LastName = LastName;
        self.PictureUrl = PictureUrl;
        self.FacebookToken = FacebookToken;
        self.GoogleToken = GoogleToken;
        self.DeviceID = DeviceID;
    }
    
    func toJSON() -> NSDictionary {
        return [
            "Email": self.Email,
            "FirstName": self.FirstName,
            "LastName": self.LastName,
            "PictureUrl": self.PictureUrl,
            "FacebookToken": self.FacebookToken,
            "GoogleToken": self.GoogleToken,
            "DeviceID": self.DeviceID
        ]
    }
}
