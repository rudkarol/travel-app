//
//  ClimateDataView.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 14/02/2025.
//

import SwiftUI

struct ClimateDataView: View {
    let climateData: [ClimateMonth]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(climateData, id: \.time) { month in
                    ClimateMonthCell(climateData: month)
                }
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    ClimateDataView(climateData: [
        ClimateMonth(time: Date(), tavg: 20.5),
        ClimateMonth(time: Date().addingTimeInterval(2592000), tavg: 22.3),
        ClimateMonth(time: Date().addingTimeInterval(5184000), tavg: nil),
        ClimateMonth(time: Date().addingTimeInterval(7776000), tavg: 26.0)
    ])
}
