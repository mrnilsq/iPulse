// GoalCreateView.swift
import SwiftUI

struct GoalCreateView: View {
    @State private var goalType = GoalType.activity
    @State private var activityGoalName = ""
    @State private var activityGoalType: ActivityGoal.GoalType = .move
    @State private var activityTargetValue: Double = 0
    
    @State private var workoutGoalName = ""
    @State private var workoutGoalType: HKWorkoutActivityType = .running
    @State private var workoutFrequency: Int = 0
    @State private var workoutTargetMetric: Double = 0
    
    @State private var error: Error?
    @Environment(\.dismiss) var dismiss
    
    enum GoalType: String, CaseIterable, Identifiable {
        case activity, workout
        var id: String { self.rawValue }
    }
    
    var onGoalCreated: (Goal) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Goal Type", selection: $goalType) {
                    ForEach(GoalType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                
                if goalType == .activity {
                    TextField("Goal Name", text: $activityGoalName)
                    Picker("Activity Goal Type", selection: $activityGoalType) {
                        ForEach(ActivityGoal.GoalType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    TextField("Target Value", value: $activityTargetValue, format: .number)
                        .keyboardType(.numberPad)
                } else {
                    TextField("Goal Name", text: $workoutGoalName)
                    Picker("Workout Type", selection: $workoutGoalType) {
                        ForEach(HKWorkoutActivityType.allCases, id: \.self) { type in
                            Text(type.name).tag(type)
                        }
                    }
                    TextField("Frequency", value: $workoutFrequency, format: .number)
                        .keyboardType(.numberPad)
                    TextField("Target Metric", value: $workoutTargetMetric, format: .number)
                        .keyboardType(.numberPad)
                }
                
                Button("Create Goal") {
                    if goalType == .activity {
                        let newGoal = ActivityGoal(
                            id: UUID(),
                            name: activityGoalName,
                            type: activityGoalType,
                            targetValue: activityTargetValue,
                            progress: 0, // Initial progress
                            period: .day //default value
                        )
                        onGoalCreated(newGoal)
                    } else {
                        let newGoal = WorkoutGoal(
                            id: UUID(),
                            name: workoutGoalName,
                            workoutType: workoutGoalType,
                            frequency: workoutFrequency,
                            targetMetric: workoutTargetMetric,
                            progress: 0
                        )
                        onGoalCreated(newGoal)
                    }
                    dismiss()
                }
            }
            .navigationTitle("Create Goal")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert(item: $error) { error in
                Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
            }
        }
    }
}
