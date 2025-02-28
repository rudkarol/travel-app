//
//  ClimateMonthCell.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 14/02/2025.
//

import SwiftUI

struct ClimateMonthCell: View {
    
    let climateData: ClimateMonth
    
    var body: some View {
        VStack(spacing: 8) {
            Text(getMonthName(date: climateData.time))
                .font(.headline)
                .foregroundColor(.primary)
                .padding([.top, .horizontal])
            
            if let tavg = climateData.tavg {
                Text(formatTemperature(celsius: tavg))
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .padding()
            } else {
                Image(systemName: "nosign")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .frame(width: 100)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.vertical)
    }
}

extension ClimateMonthCell {
    
    func getMonthName(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
    
    func formatTemperature(celsius: Float) -> String {
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.locale = Locale.current
        measurementFormatter.numberFormatter.maximumFractionDigits = 1
        
        let celsiusMeasurement = Measurement(value: Double(celsius), unit: UnitTemperature.celsius)
        
        if Locale.current.measurementSystem == .us {
            return measurementFormatter.string(from: celsiusMeasurement.converted(to: .fahrenheit))
        } else {
            return measurementFormatter.string(from: celsiusMeasurement)
        }
    }
}

#Preview {
    ClimateMonthCell(climateData: ClimateMonth(time: Date(), tavg: 12.6))
}
