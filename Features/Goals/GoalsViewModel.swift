// GoalsViewModel.swift
import SwiftUI
import Combine

class GoalsViewModel: ObservableObject {
    @Published var selectedPeriod: TimePeriod = .day
    @Published var activityGoals: [ActivityGoal] = []
    @Published var workoutGoals: [WorkoutGoal] = []
    @Published var showGoalCreation = false
    @Published var error: Error?
    
    private let localStorage: LocalStorage // Use the LocalStorage
    private var cancellables: Set<AnyCancellable> = []
    
    init(localStorage: LocalStorage = .shared) { // Default argument
        self.localStorage = localStorage
        fetchGoals() // Load goals when the view model is initialized
    }
    
    enum TimePeriod: String, CaseIterable, Identifiable {
        case day, week, month
        var id: String { self.rawValue }
    }
    
    func fetchGoals() {
        do {
            activityGoals = try localStorage.getActivityGoals()
            workoutGoals = try localStorage.getWorkoutGoals()
        } catch {
            self.error = error
        }
    }
    
    func addGoal(goal: Goal) {
        if let activityGoal = goal as? ActivityGoal {
            activityGoals.append(activityGoal)
            do {
                try localStorage.saveActivityGoal(goal: activityGoal)
            } catch {
                self.error = error
            }
        } else if let workoutGoal = goal as? WorkoutGoal {
            workoutGoals.append(workoutGoal)
            do {
                try localStorage.saveWorkoutGoal(goal: workoutGoal)
            } catch {
                self.error = error
            }
        }
        fetchGoals()
    }
    
    func updateGoal(goal: Goal) {
        if let activityGoal = goal as? ActivityGoal {
            if let index = activityGoals.firstIndex(where: { $0.id == activityGoal.id }) {
                activityGoals[index] = activityGoal
                do {
                    try localStorage.saveActivityGoal(goal: activityGoal)
                } catch {
                    self.error = error
                }
            }
        } else if let workoutGoal = goal as? WorkoutGoal {
            if let index = workoutGoals.firstIndex(where: { $0.id == workoutGoal.id }) {
                workoutGoals[index] = workoutGoal
                do {
                    try localStorage.saveWorkoutGoal(goal: workoutGoal)
                } catch {
                    self.error = error
                }
            }
        }
        fetchGoals()
    }
    
    func editActivityGoal(goal: ActivityGoal) {
        // Implementation for editing activity goal
        if let index = activityGoals.firstIndex(where: { $0.id == goal.id }) {
            activityGoals[index] = goal //update the goal
            do{
                try localStorage.saveActivityGoal(goal: goal)
            } catch {
                self.error = error
            }
        }
        fetchGoals()
    }
    
    func editWorkoutGoal(goal: WorkoutGoal) {
        // Implementation for editing workout goal
        if let index = workoutGoals.firstIndex(where: { $0.id == goal.id }) {
            workoutGoals[index] = goal //update the goal
            do{
                try localStorage.saveWorkoutGoal(goal: goal)
            } catch {
                self.error = error
            }
        }
        fetchGoals()
    }
    
     func deleteGoal(goal: Goal) {
          if let activityGoal = goal as? ActivityGoal {
              activityGoals.removeAll { $0.id == activityGoal.id }
              do {
                  try localStorage.deleteActivityGoal(goal: activityGoal)
              } catch {
                  self.error = error
              }
          } else if let workoutGoal = goal as? WorkoutGoal {
              workoutGoals.removeAll { $0.id == workoutGoal.id }
              do {
                   try localStorage.deleteWorkoutGoal(goal: workoutGoal)
               } catch {
                   self.error = error
               }
          }
          fetchGoals()
      }
}
