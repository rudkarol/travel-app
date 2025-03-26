//
//  Plan.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 17/01/2025.
//

import Foundation

struct Plan: Decodable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var description: String?
    var startDate: Date?
    var days: [DailyPlan]
}

struct DailyPlan: Decodable, Identifiable, Hashable {
    var places: [Location]?
    
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case places
    }
}

struct PlanRequestBodyModel: Encodable {
    var id: UUID
    let name: String
    let description: String?
    let startDate: Date?
    var days: [DailyPlanUpdateModel]
}

struct DailyPlanUpdateModel: Encodable {
    var places: [String]
}

struct AIPlanRequestBody: Encodable {
    let lat: Float
    let lon: Float
    let currency: String
    let days: Int
}


struct MockDataPlan: Codable {

    static let samplePlanOne = Plan(
        id: UUID(),
        name: "My first plan",
        description: "Plan description",
        startDate: Date(),
        days: [
            DailyPlan(places: [MockDataLocationDetails.sampleLocationDetails, MockDataLocationDetails.sampleLocationDetails]),
            DailyPlan(places: [MockDataLocationDetails.sampleLocationDetails])
        ]
    )
    
    static let samplePlans = [samplePlanOne]
}
