//
//  PlanListCell.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI
import CachedAsyncImage

struct PlanListCell: View {
    
    let plan: Plan
    
    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: URL(string: plan.days[0].places?[0].photos?[0].url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(height: 200)
                    .cornerRadius(12)
            } placeholder: {
                ImagePlaceholder()
                    .frame(height: 200)
                    .cornerRadius(12)
            }

            Text(plan.name)
                .bold()
                .padding(.leading)
            Text(plan.startDate ?? "")
                .padding(.leading)
        }
    }
}

#Preview {
    PlanListCell(plan: MockDataPlan.samplePlanOne)
}
