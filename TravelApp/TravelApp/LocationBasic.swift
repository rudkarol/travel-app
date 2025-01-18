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
    let imageUrl: String
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
        locationId: "321431",
        name: "Central park",
        imageUrl: "https://picsum.photos/600/400",
        addressObj: AddressObj (
            country: "USA",
            addressString: "NY, USA"
        )
    )
    
    static let samplePlaceTwo = LocationBasic(
        locationId: "54321",
        name: "Rynek gółwny",
        imageUrl: "https://picsum.photos/600/400",
        addressObj: AddressObj (
            country: "Poland",
            addressString: "Kraków, Poland"
        )
    )
    
    static let samplePlaceThree = LocationBasic(
        locationId: "62342",
        name: "Museum of Contemportary Art",
        imageUrl: "https://picsum.photos/600/400",
        addressObj: AddressObj (
            country: "Finland",
            addressString: "Kiasma, Finland"
        )
    )
    
    static let samplePlaces = [samplePlaceOne, samplePlaceTwo, samplePlaceThree]
}
