// WorkoutGoalForm.swift
import SwiftUI

struct WorkoutGoalForm: View {
    @Binding var goal: WorkoutGoal
    
    var body: some View {
        Form {
            TextField("Goal Name", text: $goal.name)
            Picker("Workout Type", selection: $goal.workoutType) {
                ForEach(HKWorkoutActivityType.allCases, id: \.self) { type in
                    Text(type.name).tag(type)
                }
            }
            TextField("Frequency", value: $goal.frequency, format: .number)
                .keyboardType(.numberPad)
            TextField("Target Metric", value: $goal.targetMetric, format: .number)
                .keyboardType(.numberPad)
        }
    }
}
