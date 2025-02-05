//
//  Location.swift
//  TravelApp
//
//  Created by osx on 18/01/2025.
//

import Foundation


struct Location: Decodable, Identifiable, Hashable {
    let locationId: String
    let name: String
    let addressObj: AddressObject
    let photos: [Photo]?
    let description: String?
    let latitude: Float
    let longitude: Float
    let category: LocationCategory
    let subcategory: [LocationCategory]
    let safetyLevel: SafetyLevel?
    
    var id: String{locationId}
}

struct AddressObject: Decodable, Hashable {
    let country: String?
    let addressString: String
}

struct LocationCategory: Decodable, Hashable {
    let name: String
}

struct SafetyLevel: Decodable, Hashable {
    let level: Int
    let pubDate: Date
    let link: String
}

struct Photo: Decodable, Hashable {
    let url: String
}




struct LocationBasic: Decodable, Identifiable, Hashable {
    let locationId: String
    let name: String
    let addressObj: AddressObject
    let photos: [Photo]?
    
    var id: String{locationId}
}

struct SearchLocationResponseModel: Decodable {
    let data: [LocationBasic]
}




struct MockDataLocationDetails {
    static let sampleLocationDetails = Location(
        locationId: "274856",
        name: "Warsaw",
        addressObj: AddressObject(
            country: "Poland",
            addressString: "Warsaw Poland"
        ),
        photos: [
            Photo(url: "https://picsum.photos/600/400"),
            Photo(url: "https://picsum.photos/600/400")
        ],
        description: "Warsaw is a mixture of relaxing green spaces, historic sites and vivid modernity. Discover the charming Old Town, Wilanów Palace and amazing Lazienki Park, where you can watch free Chopin concerts every Sunday during the summer. Experience a few of the dozens of interactive museums, including the Warsaw Uprising Museum, the Museum of the History of Polish Jews and the Copernicus Science Centre. For exciting nightlife, visit the vibrant Vistula boulevards and upscale clubs.",
        latitude: 52.229263,
        longitude: 21.01181,
        category: LocationCategory(name: "geographic"),
        subcategory: [
            LocationCategory(name: "city")
        ],
        safetyLevel: SafetyLevel(
            level: 1,
            pubDate: Date(),
            link: "http://travel.state.gov/content/travel/en/traveladvisories/traveladvisories/poland-travel-advisory.html"
        )
    )
}
