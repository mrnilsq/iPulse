// ActivitySummary.swift
import Foundation
import HealthKit

struct ActivitySummary {
    let workoutCount: Int
    let activeTime: TimeInterval
    let caloriesBurned: Double
    let steps: Int
    let activeStreak: Int
    let mostFrequentWorkoutType: HKWorkoutActivityType?
}
