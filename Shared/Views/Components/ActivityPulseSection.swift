// ActivityPulseSection.swift
import SwiftUI

struct ActivityPulseSection: View {
    let weeklyStats: WeeklyStats?
    let monthlyStats: WeeklyStats?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity Pulse")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Weekly Stats")
                        .font(.headline)
                        .foregroundColor(.gray)
                    if let weeklyStats = weeklyStats {
                        // Display weekly stats here
                        Text("Steps: \(Int(weeklyStats.dailyMetrics.reduce(0) { $0 + $1.steps }))")
                        if let avgHeartRate = weeklyStats.dailyMetrics.compactMap({$0.averageHeartRate}).average() {
                            Text("Avg Heart Rate: \(Int(avgHeartRate)) bpm")
                        }
                        if let avgSleep = weeklyStats.dailyMetrics.compactMap({$0.sleepDuration}).average(){
                            Text("Avg Sleep: \(avgSleep.formatted())")
                        }
                        
                        InteractiveChartView(weeklyStats: weeklyStats)
                    } else {
                        Text("No weekly data")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text("Monthly Stats")
                        .font(.headline)
                        .foregroundColor(.gray)
                    if let monthlyStats = monthlyStats {
                        // Display monthly stats here
                        Text("Steps: \(Int(monthlyStats.dailyMetrics.reduce(0) { $0 + $1.steps }))")
                        if let avgHeartRate = monthlyStats.dailyMetrics.compactMap({$0.averageHeartRate}).average() {
                            Text("Avg Heart Rate: \(Int(avgHeartRate)) bpm")
                        }
                        if let avgSleep = monthlyStats.dailyMetrics.compactMap({$0.sleepDuration}).average(){
                            Text("Avg Sleep: \(avgSleep.formatted())")
                        }
                        
                        InteractiveChartView(weeklyStats: monthlyStats)
                    } else {
                        Text("No monthly data")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}
