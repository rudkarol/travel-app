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
            CachedAsyncImage(url: URL(string: plan.days.first?.places?.first?.photos?.first?.url ?? "")) { image in
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
            
            if (plan.startDate != nil) {
                Text(plan.startDate!.formatted())
            }
        }
    }
}

#Preview {
    PlanListCell(plan: MockDataPlan.samplePlanOne)
}
