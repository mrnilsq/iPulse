// WorkoutGoalCard.swift
import SwiftUI

struct WorkoutGoalCard: View {
    let goal: WorkoutGoal
    var onEdit: (WorkoutGoal) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(goal.name)
                    .font(.headline)
                Text("\(goal.workoutType.name) Goal")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ProgressView(value: goal.progress, total: 1)
                    .padding(.vertical, 4)
                
                Text("\(Int(goal.progress * Double(goal.frequency))) / \(goal.frequency) times") //progress
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: {
                onEdit(goal)
            }) {
                Image(systemName: "pencil")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}
