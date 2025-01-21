//
//  Plan.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import Foundation

struct Plan: Decodable, Identifiable {
    var id = UUID()
    let name: String
    let startDate: String
    let days: [DailyPlan]?
}

struct DailyPlan: Codable {
    let places: [String]?
}




struct MockDataPlan: Codable {

    static let samplePlanOne = Plan(
        name: "My first plan",
        startDate: "20.10.2025",
        days: [
            DailyPlan(places: ["199909", "276740"]),
            DailyPlan(places: ["105127", "276740"])
        ]
    )
    
    static let samplePlans = [samplePlanOne]
}
