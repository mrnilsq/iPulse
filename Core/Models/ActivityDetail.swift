// ActivityDetail.swift
import Foundation
import HealthKit

struct ActivityDetail: Identifiable {
    let id = UUID()
    let type: HKWorkoutActivityType
    let frequency: Int
    let totalDuration: TimeInterval
    let averageDuration: TimeInterval
}
