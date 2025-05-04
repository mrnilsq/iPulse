// PerformanceInsightsView.swift
import SwiftUI

struct PerformanceInsightsView: View {
    let insights: [PerformanceInsight]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Performance Insights")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            if insights.isEmpty {
                Text("No performance insights available")
                    .foregroundColor(.gray)
            } else {
                ForEach(insights) { insight in
                    InsightView(insight: insight)
                        .padding(.bottom, 8)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}
