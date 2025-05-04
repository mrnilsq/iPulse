// InteractiveChartView.swift
import SwiftUI
import Charts

struct InteractiveChartView: View {
    let weeklyStats: WeeklyStats?
    
    var body: some View {
        if let weeklyStats = weeklyStats {
            // Use a NavigationView to enable the title and navigation bar items.
            NavigationView {
                VStack {
                    Chart(weeklyStats.dailyMetrics) { dailyMetric in //iterates through each DailyMetric
                        LineMark(
                            x: .value("Day", dailyMetric.date, unit: .day), //unit added
                            y: .value("Value", dailyMetric.steps)
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
                .navigationTitle("Weekly Steps") // Set the title of the chart
                .navigationBarTitleDisplayMode(.inline) // Make title smaller
            }
            
        } else {
            Text("No data available")
                .foregroundColor(.gray)
        }
    }
}
