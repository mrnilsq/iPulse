// ActivityGoalCard.swift
import SwiftUI

struct ActivityGoalCard: View {
    let goal: ActivityGoal
    var onEdit: (ActivityGoal) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(goal.name)
                    .font(.headline)
                Text("\(goal.type.rawValue) Goal")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ProgressView(value: goal.progress, total: 1)
                    .padding(.vertical, 4)
                
                Text("\(Int(goal.progress * goal.targetValue)) / \(Int(goal.targetValue)) \(goal.type.unit)") //progress
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
