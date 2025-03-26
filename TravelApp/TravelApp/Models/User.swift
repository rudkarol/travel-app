//
//  User.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 06/02/2025.
//

import Foundation

struct User {
    var name: String
    var email: String
}

struct ChangeEmail: Encodable {
    var newEmail: String
}
