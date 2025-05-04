// GoalEditView.swift
import SwiftUI
import HealthKit

struct GoalEditView: View {
    @Binding var goal: Goal
    var onGoalUpdated: (Goal) -> Void
    @Environment(\.dismiss) var dismiss
    
    // Use @State to create local, mutable copies for editing
    @State private var activityGoal: ActivityGoal?
    @State private var workoutGoal: WorkoutGoal?
    
    init(goal: Binding<Goal>, onGoalUpdated: @escaping (Goal) -> Void) {
        self._goal = goal
        self.onGoalUpdated = onGoalUpdated
        // Initialize the local state based on the incoming goal
        if let activity = goal.wrappedValue as? ActivityGoal {
            _activityGoal = State(initialValue: activity)
        } else if let workout = goal.wrappedValue as? WorkoutGoal {
            _workoutGoal = State(initialValue: workout)
        }
    }
    
    var body: some View {
        // Since Goal is a protocol, we need to handle the different types
        if let activityGoal = activityGoal {
            Form {
                TextField("Goal Name", text: $activityGoal.name)
                Picker("Goal Type", selection: $activityGoal.type) {
                    ForEach(ActivityGoal.GoalType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                TextField("Target Value", value: $activityGoal.targetValue, format: .number)
                    .keyboardType(.numberPad)
                
                Button("Update Goal") {
                    // Update the original goal with the modified values
                    goal = activityGoal
                    onGoalUpdated(goal)
                    dismiss()
                }
            }
            .navigationTitle("Edit Activity Goal")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        } else if let workoutGoal = workoutGoal {
            Form {
                TextField("Goal Name", text: $workoutGoal.name)
                Picker("Workout Type", selection: $workoutGoal.workoutType) {
                    ForEach(HKWorkoutActivityType.allCases, id: \.self) { type in
                        Text(type.name).tag(type)
                    }
                }
                TextField("Frequency", value: $workoutGoal.frequency, format: .number)
                    .keyboardType(.numberPad)
                TextField("Target Metric", value: $workoutGoal.targetMetric, format: .number)
                    .keyboardType(.numberPad)
                
                Button("Update Goal") {
                    // Update the original goal
                    goal = workoutGoal
                    onGoalUpdated(goal)
                    dismiss()
                }
            }
            .navigationTitle("Edit Workout Goal")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        } else {
            //Should not happen
            Text("Error: Unknown goal type")
        }
    }
}
