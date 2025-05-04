// WorkoutsSection.swift
import SwiftUI

struct WorkoutsSection: View {
    let workouts: [WorkoutModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Workouts")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            if workouts.isEmpty {
                Text("No workouts today")
                    .foregroundColor(.gray)
            } else {
                ForEach(workouts.prefix(3)) { workout in //show only top 3
                    WorkoutCard(workout: workout)
                        .padding(.bottom, 8)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}
