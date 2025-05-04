// MetricsChart.swift
import SwiftUI
import Charts

struct MetricsChart: View {
    let weeklyMetrics: DailyMetrics? // Changed to DailyMetrics
    let metricType: MetricType
    
    enum MetricType: String, CaseIterable, Identifiable {
        case heartRate, sleep, standHours
        var id: String { self.rawValue }
        
        var displayName: String {
            switch self {
            case .heartRate: return "Avg Heart Rate"
            case .sleep: return "Sleep Duration"
            case .standHours: return "Stand Hours"
            }
        }
    }
    
    var body: some View {
        if let weeklyMetrics = weeklyMetrics {
            // Use a NavigationView to enable the title and navigation bar items.
            NavigationView{
                VStack {
                    Chart(weeklyMetrics.dailyMetrics) { dailyMetric in //iterates
                        LineMark(
                            x: .value("Day", dailyMetric.date, unit: .day), //unit added
                            y: .value(metricType.displayName, metricValue(for: dailyMetric))
                        )
                        .interpolationMethod(.catmullRom)
                        .symbol(Circle())
                        .symbolSize(8)
                    }
                    .chartXAxis {
                        AxisMarks(preset: .automatic,
                                  position: .bottom,
                                  showSeparator: true)
                    }
                    .chartYAxis {
                        AxisMarks(preset: .automatic,
                                  position: .leading,
                                  showSeparator: true)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                }
                .navigationTitle(metricType.displayName) // Set the title
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            Text("No data available")
                .foregroundColor(.gray)
        }
    }
    
    func metricValue(for dailyMetric: DailyMetric) -> Double {
        switch metricType {
        case .heartRate: return dailyMetric.averageHeartRate ?? 0 // Provide a default value
        case .sleep: return dailyMetric.sleepDuration ?? 0        // Provide a default value
        case .standHours: return Double(dailyMetric.standHours)
        }
    }
}

