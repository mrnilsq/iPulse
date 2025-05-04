// ActivityGoalForm.swift
import SwiftUI

struct ActivityGoalForm: View {
    @Binding var goal: ActivityGoal
    
    var body: some View {
        Form {
            TextField("Goal Name", text: $goal.name)
            Picker("Goal Type", selection: $goal.type) {
                ForEach(ActivityGoal.GoalType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            TextField("Target Value", value: $goal.targetValue, format: .number)
                .keyboardType(.numberPad)
        }
    }
}
