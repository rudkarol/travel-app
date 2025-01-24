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
    
    private func updateUserPlans() async throws {
        let endpointUrl = "/user/me/favorites/"
        var plansToUpdate: [PlanUpdateModel] = []
        
        for plan in plans {
            var plan_data = PlanUpdateModel(
                name: plan.name,
                description: plan.description,
                startDate: plan.startDate,
                days: [])
            
            var day = DailyPlanUpdateModel(places: [])
            
            for planDay in plan.days {
                let ids = planDay.places?.map { $0.id }
                day.places = ids ?? []
            }
            
            plan_data.days.append(day)
        }
        
        try await TravelApiRequest.shared.putData(endpointUrl: endpointUrl, body: plansToUpdate)
    }
}
