//
//  JSONEncoder+Ext.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 10/02/2025.
//

import Foundation


extension JSONEncoder {
    static func withFastApiDateEncodingStrategy() -> JSONEncoder {
        let encoder = JSONEncoder()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        return encoder
    }
}
