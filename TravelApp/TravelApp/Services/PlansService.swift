//
//  PlansService.swift
//  TravelApp
//
//  Created by osx on 24/01/2025.
//

import Foundation
import Observation

@Observable
class PlansService {
    
    var plans: [Plan] = []
    
    
    func addPlan(name: String) {
        plans.append(Plan(name: name, description: nil, startDate: nil, days: []))
    }
    
    func getUserPlans() async throws {
        let locale = NSLocale.current
        let currencyCode = locale.currency?.identifier
        let endpointUrl = "/user/me/trips/?currency=\(currencyCode ?? "usd")"
        
        let data = try await TravelApiRequest.shared.getData(endpointUrl: endpointUrl)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            plans = try decoder.decode([Plan].self, from: data)
        } catch {
            print("get plans decoder error")
            throw AppError.invalidData
        }
    }
    
    func updateUserPlans() async throws {
        let endpointUrl = "/user/me/favorites/"
        var plansToUpdate: [PlanUpdateModel] = []
        
        for plan in plans {
            var plan_data = PlanUpdateModel(
                name: plan.name,
                description: plan.description,
                startDate: plan.startDate,
                days: [])
            
            for planDay in plan.days {
                let ids = planDay.places?.map { $0.id }
                let day = DailyPlanUpdateModel(places: ids ?? [])
//                ??
                plan_data.days.append(day)
            }
//            ??
            plansToUpdate.append(plan_data)
        }
        
        try await TravelApiRequest.shared.putData(endpointUrl: endpointUrl, body: plansToUpdate)
    }
}
