// ActivityGoal.swift
import Foundation

// Define the Goal protocol
protocol Goal {
    var id: UUID { get }
    var name: String { get set } // Added setter
    var type: GoalType { get set } //Added setter
    var targetValue: Double { get set } // Added setter
    var progress: Double { get set }  // Added setter
    var period: GoalsViewModel.TimePeriod { get set } // Added setter
    var unit: String { get } // Computed property, so no setter
}

struct ActivityGoal: Goal, Identifiable, Codable {
    let id: UUID
    var name: String
    var type: GoalType
    var targetValue: Double
    var progress: Double
    var period: GoalsViewModel.TimePeriod

    // Add a computed property for the unit based on the type
    var unit: String {
        switch type {
        case .move: return "cal"
        case .steps: return "steps"
        case .exercise: return "min"
        }
    }

    enum GoalType: String, CaseIterable, Codable {
        case move, steps, exercise

        var rawValue: String { // rawValue is already provided by String
            switch self {
            case .move: return "Move"
            case .steps: return "Steps"
            case .exercise: return "Exercise"
            }
        }
    }
}

