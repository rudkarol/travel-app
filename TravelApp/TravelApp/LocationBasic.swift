//
//  Place.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import Foundation

struct LocationBasic: Decodable, Identifiable {
    let locationId: String
    let name: String
    let photos: [Photo]
    let addressObj: AddressObj
    
    var id: String { locationId }
}

struct AddressObj: Decodable {
    let country: String
    let addressString: String
}

struct LocationBasicResponse : Decodable {
    let data: [LocationBasic]
}

struct MockDataPlace {
    static let samplePlaceOne = LocationBasic(
        locationId: "105127",
        name: "Central park",
        photos: [
            Photo(url: "https://picsum.photos/600/400"),
            Photo(url: "https://picsum.photos/600/400")
        ],
        addressObj: AddressObj (
            country: "USA",
            addressString: "NY, USA"
        )
    )
    
    static let samplePlaceTwo = LocationBasic(
        locationId: "276740",
        name: "Rynek gółwny",
        photos: [
            Photo(url: "https://picsum.photos/600/400"),
            Photo(url: "https://picsum.photos/600/400")
        ],
        addressObj: AddressObj (
            country: "Poland",
            addressString: "Kraków, Poland"
        )
    )
    
    static let samplePlaceThree = LocationBasic(
        locationId: "199909",
        name: "Museum of Contemportary Art Kiasma",
        photos: [
            Photo(url: "https://picsum.photos/600/400"),
            Photo(url: "https://picsum.photos/600/400")
        ],
        addressObj: AddressObj (
            country: "Finland",
            addressString: "Helsinki, Finland"
        )
    )
    
    static let samplePlaces = [samplePlaceOne, samplePlaceTwo, samplePlaceThree]
}
