//
//  JSONDecoder+Ext.swift
//  TravelApp
//
//  Created by osx on 26/01/2025.
//

import Foundation

extension JSONDecoder {
    static func withFastApiDateDecodingStrategy() -> JSONDecoder {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            let formatter = DateFormatter()
            
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if let date = formatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Incorrect date format: \(dateString)"
                )
            }
        }
        
        return decoder
    }
}
