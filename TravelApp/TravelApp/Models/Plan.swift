//
//  Plan.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import Foundation

struct Plan: Decodable, Identifiable, Hashable {
    let name: String
    let description: String?
    let startDate: String?
    let days: [DailyPlan]
    
    var id: String{name}
}

struct DailyPlan: Decodable, Identifiable, Hashable {
    let places: [Location]?
    
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case places
    }
}

struct PlanUpdateModel: Encodable {
    let name: String
    let description: String?
    let startDate: String?
    var days: [DailyPlanUpdateModel]
}

struct DailyPlanUpdateModel: Encodable {
    var places: [String]
}




struct MockDataPlan: Codable {

    static let samplePlanOne = Plan(
        name: "My first plan",
        description: "Plan description",
        startDate: "20.10.2025",
        days: [
            DailyPlan(places: [MockDataLocationDetails.sampleLocationDetails, MockDataLocationDetails.sampleLocationDetails]),
            DailyPlan(places: [MockDataLocationDetails.sampleLocationDetails])
        ]
    )
    
    static let samplePlans = [samplePlanOne]
}
