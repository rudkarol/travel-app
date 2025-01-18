//
//  Plan.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import Foundation

struct Plan: Codable, Identifiable {
    let id: Int
    let name: String
    let startDate: String
    let endDate: String
    let places: [LocationBasic]
}

struct MockDataPlan {
    static let samplePlanOne = Plan(
        id: 001,
        name: "My first plan",
        startDate: "20.10.2025",
        endDate: "18.11.2025",
        places: [MockDataPlace.samplePlaceOne, MockDataPlace.samplePlaceTwo]
    )
    
    static let samplePlans = [samplePlanOne]
}
