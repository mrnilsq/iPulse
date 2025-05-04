// WorkoutCard.swift

import SwiftUI
import HealthKit

struct WorkoutCard: View {
    let workout: WorkoutModel
    
    var body: some View {
        HStack {
            Image(systemName: workout.workoutType.workoutIcon) //use extension
                .font(.title)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(workout.workoutType.name) //use extension
                    .font(.headline)
                Text("\(workout.duration.formatted())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                if let distance = workout.distance {
                    Text("\(distance.formatted()) meters")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Text(workout.startDate.formatted(.relative(presentation: .named)))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
