// GoalsView.swift
import SwiftUI

struct GoalsView: View {
    @ObservedObject var viewModel = GoalsViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                TimePeriodPicker(selectedPeriod: $viewModel.selectedPeriod)
                    .padding(.bottom)
                
                ActivityGoalsSection(
                    activityGoals: viewModel.activityGoals,
                    onEdit: viewModel.editActivityGoal
                )
                .padding(.bottom)
                
                WorkoutGoalsSection(
                    workoutGoals: viewModel.workoutGoals,
                    onEdit: viewModel.editWorkoutGoal
                )
                .padding(.bottom)
                
                Button("Add New Goal") {
                    viewModel.showGoalCreation = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Spacer()
            }
            .padding()
        }
        .background(Color.white.opacity(0.05))
        .navigationTitle("Goals")
        .sheet(isPresented: $viewModel.showGoalCreation) {
            GoalCreateView(
                onGoalCreated: { goal in
                    viewModel.addGoal(goal: goal)
                }
            )
        }
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            viewModel.fetchGoals()
        }
    }
}
