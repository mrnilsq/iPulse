// ActivityTrendChart.swift
import SwiftUI
import Charts

struct ActivityTrendChart: View {
    let activities: [ActivityDetail]
    
    var body: some View {
        if !activities.isEmpty {
            // Use a NavigationView to enable the title and navigation bar items.
            NavigationView {
                Chart(activities) { activity in
                    BarMark(
                        x: .value("Activity", activity.type.name), //use extension
                        y: .value("Duration", activity.totalDuration)
                    )
                    .annotation(position: .top) {
                        Text(activity.totalDuration.formatted())
                            .font(.caption)
                    }
                }
                .chartXAxisLabel(alignment: .center) {
                    Text("Activity Type")
                }
                .chartYAxisLabel(alignment: .leading) {
                    Text("Total Duration")
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .navigationTitle("Activity Trends") // Set the title of the chart
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            Text("No activity data available")
                .foregroundColor(.gray)
        }
    }
}
