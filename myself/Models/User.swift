//
//  User.swift
//  myself
//
//  Created by Kemal Taskin on 02.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation

class User
{
    var Email: String
    var FirstName: String
    var LastName: String
    var PictureUrl: String
    var Score: Int
    
    init(Email: String, FirstName: String, LastName: String,
         PictureUrl: String, Score: Int)
    {
        self.Email = Email;
        self.FirstName = FirstName;
        self.LastName = LastName;
        self.PictureUrl = PictureUrl;
        self.Score = Score;
    }
    
    func GetFullName() -> String {
        
        return FirstName + " " + LastName
    }
}
