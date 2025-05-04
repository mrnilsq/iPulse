// DailyMetrics.swift
import Foundation

struct DailyMetrics {
    var dailyMetrics: [DailyMetric]
}

struct DailyMetric: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let steps: Double
    let averageHeartRate: Double?
    let sleepDuration: TimeInterval?
    let standHours: Int
}
