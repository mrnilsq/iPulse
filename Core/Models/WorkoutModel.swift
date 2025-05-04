// WorkoutModel.swift
import Foundation
import HealthKit

struct WorkoutModel: Identifiable {
    let id: UUID
    let workoutType: HKWorkoutActivityType
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let distance: Double?
    
    init(workout: HKWorkout) {
        self.id = workout.uuid
        self.workoutType = workout.workoutActivityType
        self.startDate = workout.startDate
        self.endDate = workout.endDate
        self.duration = workout.duration
        self.distance = workout.totalDistance?.doubleValue(for: .meter())
    }
}
