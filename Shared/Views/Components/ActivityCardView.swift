// ActivityCardView.swift
import SwiftUI
import HealthKit
struct ActivityCardView: View {
    let activity: ActivityDetail
    
    var body: some View {
        HStack {
            Image(systemName: activity.type.workoutIcon) //use extension
                .font(.title)
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(activity.type.name) //use extension
                    .font(.headline)
                Text("Frequency: \(activity.frequency)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Total: \(activity.totalDuration.formatted())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
