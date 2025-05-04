// HKWorkoutActivityType+Extensions.swift
import HealthKit

extension HKWorkoutActivityType: CaseIterable, Identifiable {
    public static var allCases: [HKWorkoutActivityType] {
        return [
            .running,
            .walking,
            .cycling,
            .swimming,
            .hiking,
            .downhillSkiing,
            .snowboarding,
            .elliptical,
            .functionalStrengthTraining, // Corrected: .strengthTraining replaced
            .other,
            .yoga,
            .mindAndBody,
            .crossTraining,
            .stairs,
            .traditionalStrengthTraining,
            .fitnessGaming,
            .paddleSports,
            .flexibility,
            .barre,
            .coreTraining,
            .pilates,
            .mixedCardio,
            .highIntensityIntervalTraining,
            //.prepRecovery, // Removed: No longer a direct case
            .soccer,
            .tennis,
            .basketball
        ]
    }

    public var id: UInt {
        return rawValue
    }

    var name: String {
        switch self {
        case .running: return "Running"
        case .walking: return "Walking"
        case .cycling: return "Cycling"
        case .swimming: return "Swimming"
        case .hiking: return "Hiking"
        case .downhillSkiing: return "Downhill Skiing"
        case .snowboarding: return "Snowboarding"
        case .elliptical: return "Elliptical"
        case .functionalStrengthTraining: return "Strength Training" // Corrected
        case .other: return "Other"
        case .yoga: return "Yoga"
        case .dance: return "Dance"
        case .mindAndBody: return "Mind and Body"
        case .crossTraining: return "Cross Training"
        case .stairs: return "Stairs"
        case .traditionalStrengthTraining: return "Traditional Strength Training"
        case .fitnessGaming: return "Fitness Gaming"
        case .paddleSports: return "Paddle Sports"
        case .flexibility: return "Flexibility"
        case .barre: return "Barre"
        case .coreTraining: return "Core Training"
        case .pilates: return "Pilates"
        case .mixedCardio: return "Mixed Cardio"
        case .highIntensityIntervalTraining: return "High Intensity Interval Training"
        //case .prepRecovery: return "Prep Recovery" // Removed
        case .soccer: return "Soccer"
        case .tennis: return "Tennis"
        case .basketball: return "Basketball"
        default: return "Unknown"
        }
    }

    var workoutIcon: String {
        switch self {
        case .running: return "figure.run"
        case .walking: return "figure.walk"
        case .cycling: return "bicycle"
        case .swimming: return "figure.swimming"
        case .hiking: return "mountain.2"
        case .downhillSkiing: return "snowboard"
        case .snowboarding: return "snowboard"
        case .elliptical: return "elliptical"
        case .functionalStrengthTraining: return "dumbbell.fill" // Corrected
        case .other: return "questionmark"
        case .yoga: return "figure.yoga"
        case .dance: return "figure.dance"
        case .mindAndBody: return "heart.circle"
        case .crossTraining: return "figure.gymnastics"
        case .stairs: return "stairs"
        case .traditionalStrengthTraining: return "dumbbell"
        case .fitnessGaming: return "gamecontroller.fill"
        case .paddleSports: return "canoe"
        case .flexibility: return "figure.flexibility"
        case .barre: return "barbell.fill"
        case .coreTraining: return "figure.core.training"
        case .pilates: return "figure.pilates"
        case .mixedCardio: return "figure.mixed.cardio"
        case .highIntensityIntervalTraining: return "bolt.fill"
       // case .prepRecovery: return "figure.strengthtraining.traditional" // Removed
        case .soccer: return "sportscourt"
        case .tennis: return "tennis.racket"
        case .basketball: return "sportscourt"
        default: return "questionmark"
        }
    }
}
