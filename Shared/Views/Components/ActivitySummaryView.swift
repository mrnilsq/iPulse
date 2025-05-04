// ActivitySummaryView.swift
import SwiftUI

struct ActivitySummaryView: View {
    let summary: ActivitySummary?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity Summary")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            if let summary = summary {
                HStack {
                    SummaryMetricView(title: "Workouts", value: "\(summary.workoutCount)", icon: "figure.walk")
                    SummaryMetricView(title: "Active Time", value: summary.activeTime.formatted(), icon: "timer")
                    SummaryMetricView(title: "Calories", value: "\(Int(summary.caloriesBurned))", icon: "flame.fill")
                }
                HStack {
                    SummaryMetricView(title: "Steps", value: "\(summary.steps)", icon: "foot.fill")
                    SummaryMetricView(title: "Streak", value: "\(summary.activeStreak) days", icon: "bolt.fill")
                    SummaryMetricView(
                        title: "Most Frequent",
                        value: summary.mostFrequentWorkoutType?.name ?? "N/A", //use extension
                        icon: summary.mostFrequentWorkoutType?.workoutIcon ?? "questionmark"
                    )
                }
            } else {
                Text("No activity summary available")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

// Helper view for displaying a single metric in the summary
struct SummaryMetricView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.blue)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
    }
}
