//
//  User.swift
//  TravelApp
//
//  Created by osx on 18/01/2025.
//

import JWTDecode

struct User: Decodable {
    let userId: String
    let email: String
    var favoritePlaces: [String]?
    var trips: [Plan]?
}
