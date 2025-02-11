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
    
    func updatePlan(planId: UUID) async throws {
        let endpointUrl = "/trip/update"
        
        guard let planIndex = plans.firstIndex(where: { $0.id == planId }) else { return }
        let plan = plans[planIndex]
        
        var planData = PlanUpdateModel(
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
        
        dump(planData)
        
        try await TravelApiRequest.shared.patchData(endpointUrl: endpointUrl, body: planData)
    }
    
    func deletePlan(id: UUID) async throws {
        let endpointUrl = "/trip/delete?trip_id=\(id)"
        
        let _ = try await TravelApiRequest.shared.deleteData(endpointUrl: endpointUrl)
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
