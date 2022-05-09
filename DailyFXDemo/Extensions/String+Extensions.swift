//
//  String+Extensions.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 06/05/2022.
//

import Foundation

public extension Int {
    func convertToTimeInterval() -> TimeInterval {
        Double(self)
    }
    
    func  fromUnixTimeStamp() -> Date? {
            let date = Date(timeIntervalSince1970: TimeInterval(self/1000))
        return date
    }
    
    func convertToDisplayDate() -> String {
        let timeInterval = TimeInterval(self/1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
    
        return dateFormatter.string(from: date)
    }
}
