//
//  PlansService.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 24/01/2025.
//

import Foundation
import Observation

@Observable
class PlansService {
    
    var plans: [Plan] = []
    
    
    func addPlan(plan: Plan) async throws {
        plans.append(plan)
        
        let endpointUrl = "/trip/create"

        let planData = PlanRequestBodyModel(
            id: plan.id,
            name: plan.name,
            description: plan.description,
            startDate: plan.startDate,
            days: [])
        
        try await FastApiRequest.shared.putData(endpointUrl: endpointUrl, body: planData)
    }
    
    func removePlace(from planId: UUID, dayIndex: Int, placeIndex: Int) {
        guard let planIndex = plans.firstIndex(where: { $0.id == planId }) else { return }
        guard plans[planIndex].days.indices.contains(dayIndex),
              plans[planIndex].days[dayIndex].places!.indices.contains(placeIndex) else { return }
        
        plans[planIndex].days[dayIndex].places!.remove(at: placeIndex)
    }
    
    func getUserPlans() async throws {
        if plans.isEmpty {
            let locale = NSLocale.current
            let currencyCode = locale.currency?.identifier
            let endpointUrl = "/trip/plans?currency=\(currencyCode ?? "usd")"
            
            let data = try await FastApiRequest.shared.getData(endpointUrl: endpointUrl)
            
            do {
                let decoder = JSONDecoder.withFastApiDateDecodingStrategy()
                plans = try decoder.decode([Plan].self, from: data)
            } catch {
                print("get plans decoder error")
                throw AppError.invalidData
            }
        }
    }
    
    func updatePlan(planId: UUID) async throws {
        let endpointUrl = "/trip/update"
        
        guard let planIndex = plans.firstIndex(where: { $0.id == planId }) else { return }
        let plan = plans[planIndex]
        
        var planData = PlanRequestBodyModel(
            id: plan.id,
            name: plan.name,
            description: plan.description,
            startDate: plan.startDate,
            days: [])
        
        for planDay in plan.days {
            let ids = planDay.places?.map { $0.id }
            let day = DailyPlanUpdateModel(places: ids ?? [])
            planData.days.append(day)
        }
        
        try await FastApiRequest.shared.patchData(endpointUrl: endpointUrl, body: planData)
    }
    
    func deletePlan(id: UUID) async throws {
        let endpointUrl = "/trip/delete?trip_id=\(id)"
        
        let _ = try await FastApiRequest.shared.deleteData(endpointUrl: endpointUrl)
    }
    
    func generateAIPlan(latitude: Float, longitude: Float, days: Int) async throws {
        let locale = NSLocale.current
        let currencyCode = locale.currency?.identifier
        let endpointUrl = "/trip/generate"
        var planResponse: Plan
        
        
        let body = AIPlanRequestBody(lat: latitude, lon: longitude, currency: "\(currencyCode ?? "usd")", days: days)
        
        let data = try await FastApiRequest.shared.postData(endpointUrl: endpointUrl, body: body)

        do {
            let decoder = JSONDecoder.withFastApiDateDecodingStrategy()
            planResponse = try decoder.decode(Plan.self, from: data)
        } catch {
            print("get plan decoder error")
            throw AppError.invalidData
        }
        
        self.plans.append(planResponse)
    }
    
    func clearPlans() {
        self.plans.removeAll()
    }
}
