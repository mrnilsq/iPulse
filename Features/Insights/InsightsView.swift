import SwiftUI

// Assuming PerformanceInsight and InsightType are defined in PerformanceInsight.swift
// (which you provided earlier)

struct InsightView: View {
    let insight: PerformanceInsight

    var body: some View {
        HStack {
            Text(insight.type.displayName)
                .font(.headline)
                .foregroundColor(.blue)
            Spacer()
            Text("\(insight.value.formatted()) \(insight.unit)")
                .font(.title3)
                .fontWeight(.semibold) // Corrected: Use .semibold, not .
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
        }
    }
}

// Example usage (for demonstration or testing within this file)
struct InsightView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample PerformanceInsight instance for the preview
        let sampleInsight = PerformanceInsight(
            type: .averageWorkoutDuration,
            value: 45.5, // Example value
            unit: "min"    // Example unit
        )

        InsightView(insight: sampleInsight)
            .padding() // Add padding for better preview appearance
            .background(Color.gray.opacity(0.2))
            .previewLayout(.sizeThatFits)
    }
}
