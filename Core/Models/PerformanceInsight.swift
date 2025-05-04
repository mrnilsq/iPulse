// PerformanceInsight.swift
import Foundation

struct PerformanceInsight: Identifiable {
    let id = UUID()
    let type: InsightType
    let value: Double
    let unit: String
    
    enum InsightType: String, CaseIterable, Identifiable {
        case averageWorkoutDuration, longestWorkout, mostActiveDay
        
        var id: String { self.rawValue }
        
        var displayName: String {
            switch self {
            case .averageWorkoutDuration: return "Avg Workout Duration"
            case .longestWorkout: return "Longest Workout"
            case .mostActiveDay: return "Most Active Day"
            }
        }
    }
}
