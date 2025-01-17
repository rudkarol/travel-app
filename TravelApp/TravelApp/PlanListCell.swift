//
//  PlanListCell.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct PlanListCell: View {
    
    let plan: Plan
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: plan.places[0].imageUrl)) {image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(8)
            } placeholder: {
                Image("plan-placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(8)
            }

            Text(plan.name)
                .bold()
                .padding(.leading)
//            TODO: DatePicker range
            Text("\(plan.startDate) to \(plan.endDate)")
                .padding(.leading)
        }
    }
}

#Preview {
    PlanListCell(plan: MockDataPlan.samplePlanOne)
}
