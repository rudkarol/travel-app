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
    
    
    func addPlan(plan: Plan) {
        plans.append(plan)
//        TODO save
    }
    
    func getUserPlans() async throws {
        if plans.isEmpty {
            let locale = NSLocale.current
            let currencyCode = locale.currency?.identifier
            let endpointUrl = "/user/me/trips/?currency=\(currencyCode ?? "usd")"
            
            let data = try await TravelApiRequest.shared.getData(endpointUrl: endpointUrl)
            
            do {
                let decoder = JSONDecoder.withFastApiDateDecodingStrategy()
                plans = try decoder.decode([Plan].self, from: data)
            } catch {
                print("get plans decoder error")
                throw AppError.invalidData
            }
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
    
    func generateAIPlan(latitude: Float, longitude: Float, days: Int) async throws {
        let locale = NSLocale.current
        let currencyCode = locale.currency?.identifier
        let endpointUrl = "/trip/generate"
        var planResponse: Plan
        
        
        let body = AIPlanRequestBody(lat: latitude, lon: longitude, currency: "\(currencyCode ?? "usd")", days: days)
        dump(body)
        
        let data = try await TravelApiRequest.shared.postData(endpointUrl: endpointUrl, body: body)

        do {
            let decoder = JSONDecoder.withFastApiDateDecodingStrategy()
            planResponse = try decoder.decode(Plan.self, from: data)
        } catch {
            print("get plan decoder error")
            throw AppError.invalidData
        }
        
//        TODO: try catch
        addPlan(plan: planResponse)
    }
}
