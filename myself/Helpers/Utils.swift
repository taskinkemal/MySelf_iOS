//
//  Utils.swift
//  myself
//
//  Created by Kemal Taskin on 02.12.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation

final class Utils {
    
    static func GetDay(date: Date) -> Int {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2018
        dateComponents.month = 1
        dateComponents.day = 1
        
        // Create date from components
        let calendar = Calendar.current // user calendar
        let startDate = calendar.date(from: dateComponents)
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate!)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day!
    }
    
    static func GetToday() -> Int {
    
        return GetDay(date: Date())
    }
}
