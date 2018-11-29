//
//  DataStore.swift
//  myself
//
//  Created by Kemal Taskin on 26.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation

final class DataStore {
    
    static func GetAccessToken() -> String? {
        
        return UserDefaults.standard.object(forKey: "AccessToken") as? String
    }
    
    static func SetAccessToken(accessToken: String) {
        
        return UserDefaults.standard.set(accessToken, forKey: "AccessToken")
    }
}
