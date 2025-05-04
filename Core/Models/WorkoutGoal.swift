// WorkoutGoal.swift
import Foundation
import HealthKit

struct WorkoutGoal: Goal, Identifiable, Codable {
    let id: UUID
    var name: String
    let workoutType: HKWorkoutActivityType
    let frequency: Int
    let targetMetric: Double // e.g., distance, duration
    var progress: Double
}
