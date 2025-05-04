// WeeklyHealthMetricsView.swift
import SwiftUI

struct WeeklyHealthMetricsView: View {
    let weeklyMetrics: DailyMetrics?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Weekly Health Metrics")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            if let weeklyMetrics = weeklyMetrics {
                HStack {
                    MetricsChart(weeklyMetrics: weeklyMetrics, metricType: .heartRate)
                    MetricsChart(weeklyMetrics: weeklyMetrics, metricType: .sleep)
                }
                MetricsChart(weeklyMetrics: weeklyMetrics, metricType: .standHours)
            } else {
                Text("No weekly health metrics available")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

