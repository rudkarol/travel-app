//
//  Place.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import Foundation

struct Place: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let location: String
    let imageUrl: String
}

//struct PlacesResponse: Decodable {
//    let response: [Place]
//}

struct MockData {
    static let samplePlaceOne = Place(id: 001, name: "New York", description: "A wonderfull place", location: "NY, USA", imageUrl: "https://picsum.photos/600/400")
    static let samplePlaceTwo = Place(id: 002, name: "Krakow", description: "A really wonderfull place", location: "Poland", imageUrl: "https://picsum.photos/600/400")
    static let samplePlaceThree = Place(id: 003, name: "Helsinki", description: "Nice place", location: "Finland", imageUrl: "https://picsum.photos/600/400")
    
    static let samplePlaces = [samplePlaceOne, samplePlaceTwo, samplePlaceThree]
}
