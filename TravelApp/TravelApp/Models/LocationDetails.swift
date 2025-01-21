//
//  LocationDetails.swift
//  TravelApp
//
//  Created by osx on 18/01/2025.
//

import Foundation

struct LocationDetails: Decodable, Identifiable {
    let locationId: String
    let name: String
    let addressObj: AddressObj
    let photos: [Photo]?
    let description: String?
    let latitude: Float
    let longitude: Float
    let category: LocationCategory
    let subcategory: [LocationCategory]
    let safetyLevel: SafetyLevel?
    
    var id: String{locationId}
}

struct AddressObject: Decodable {
    let country: String?
    let addressString: String
}

struct LocationCategory: Decodable {
    let name: String
}

struct SafetyLevel: Decodable {
    let level: Int
    let pubDate: String
    let link: String
}




struct MockDataLocationDetails {
    static let sampleLocationDetails = LocationDetails(
        locationId: "274856",
        name: "Warsaw",
        addressObj: AddressObj(
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
            pubDate: "2024-05-01T00:00:00",
            link: "http://travel.state.gov/content/travel/en/traveladvisories/traveladvisories/poland-travel-advisory.html"
        )
    )
}
