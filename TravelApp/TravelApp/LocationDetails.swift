//
//  LocationDetails.swift
//  TravelApp
//
//  Created by osx on 18/01/2025.
//

import Foundation

struct LocationDetails: Decodable {
    let locationId: String
    let name: String
    let imageUrl: String
    let addressObj: AddressObj
    let description: String
    let latitude: Double
    let longitude: Double
    let category: LocationCategory
    let subcategory: [LocationCategory]
    let safetyLevel: SafetyLevel
    
    var id: String { locationId }
    
    init(locationId: String,
         name: String,
         imageUrl: String,
         addressObj: AddressObj,
         description: String,
         latitude: Double,
         longitude: Double,
         category: LocationCategory,
         subcategory: [LocationCategory],
         safetyLevel: SafetyLevel
    ) {
        self.locationId = locationId
        self.name = name
        self.imageUrl = imageUrl
        self.addressObj = addressObj
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        self.subcategory = subcategory
        self.safetyLevel = safetyLevel
    }
}

struct AddressObject: Decodable {
    let country: String
    let addressString: String
    
    init(country: String, addressString: String) {
        self.country = country
        self.addressString = addressString
    }
}

struct Category: Decodable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct Subcategory: Decodable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct SafetyLevel: Decodable {
    let level: Int
    let pubDate: Date
    let link: String
    
    private enum CodingKeys: String, CodingKey {
        case level, pubDate, link
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        level = try container.decode(Int.self, forKey: .level)
        link = try container.decode(String.self, forKey: .link)
        
        let dateString = try container.decode(String.self, forKey: .pubDate)
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            pubDate = date
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .pubDate,
                in: container,
                debugDescription: "Date string does not match ISO8601 format"
            )
        }
    }
    
    init(level: Int, pubDate: String, link: String) {
        self.level = level
        self.link = link
        
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: pubDate) {
            self.pubDate = date
        } else {
            self.pubDate = Date()
        }
    }
}




struct MockDataLocationDetails {
    static let sampleLocationDetails = LocationDetails(
        locationId: "274856",
        name: "Warsaw",
        imageUrl: "https://picsum.photos/600/400",
        addressObj: AddressObj(
            country: "Poland",
            addressString: "Warsaw Poland"
        ),
        description: "Warsaw is a mixture of relaxing green spaces, historic sites and vivid modernity. Discover the charming Old Town, Wilanów Palace and amazing Lazienki Park, where you can watch free Chopin concerts every Sunday during the summer. Experience a few of the dozens of interactive museums, including the Warsaw Uprising Museum, the Museum of the History of Polish Jews and the Copernicus Science Centre. For exciting nightlife, visit the vibrant Vistula boulevards and upscale clubs.",
        latitude: 52.229263,
        longitude: 21.01181,
        category: LocationCategory(name: "geographic"),
        subcategory: [
            LocationCategory(name: "city")
        ],
        safetyLevel: SafetyLevel(
            level: 1,
            pubDate: "2024-05-01T00:00:00",
            link: "http://travel.state.gov/content/travel/en/traveladvisories/traveladvisories/poland-travel-advisory.html"
        )
    )
}
