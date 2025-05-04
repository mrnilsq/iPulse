// StatusBarSection.swift
import SwiftUI

struct StatusBarSection: View {
    let dailyMetrics: DailyMetrics?
    
    var body: some View {
        HStack {
            if let dailyMetrics = dailyMetrics, let dailyMetric = dailyMetrics.dailyMetrics.first { //gets the first element
                MetricView(
                    title: "Calories",
                    value: dailyMetric.steps, //use steps for calories
                    unit: "cal",
                    icon: "flame.fill"
                )
                MetricView(
                    title: "Steps",
                    value: dailyMetric.steps,
                    unit: "steps",
                    icon: "figure.walk"
                )
                MetricView(
                    title: "Heart Rate",
                    value: dailyMetric.averageHeartRate ?? 0, // Provide a default value
                    unit: "bpm",
                    icon: "heart.fill"
                )
                MetricView(
                    title: "Stand Hours",
                    value: Double(dailyMetric.standHours),
                    unit: "hr",
                    icon: "hourglass"
                )
            } else {
                Text("No data available")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

// Helper view for displaying a single metric
struct MetricView: View {
    let title: String
    let value: Double
    let unit: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.blue)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text("\(Int(value)) \(unit)")
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
    }
}
