// HomeViewModel.swift
import SwiftUI
import HealthKit
import Combine

class HomeViewModel: ObservableObject {
    @Published var dailyMetrics: DailyMetrics?
    @Published var recentWorkouts: [WorkoutModel] = []
    @Published var weeklyStats: WeeklyStats?
    @Published var monthlyStats: WeeklyStats? // Reusing WeeklyStats for monthly
    @Published var error: Error?
    @Published var isLoading = false
    
    private let healthKitManager: HealthKitManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(healthKitManager: HealthKitManager = .shared) { //default argument
        self.healthKitManager = healthKitManager
    }
    
    func startFetchingData() {
         fetchData()
         //setup background refresh.
    }
    
    func stopFetchingData() {
        cancellables.removeAll()
    }

    @MainActor
    func fetchData() async {
        isLoading = true
        error = nil
        
        async let dailyMetricsResult = healthKitManager.getDailyMetrics()
        async let recentWorkoutsResult = healthKitManager.getRecentWorkouts()
        async let weeklyStatsResult = healthKitManager.getWeeklyStats()
        async let monthlyStatsResult = healthKitManager.getMonthlyStats()
        
        do {
            (dailyMetrics, recentWorkouts, weeklyStats, monthlyStats) = try await (dailyMetricsResult, recentWorkoutsResult, weeklyStatsResult, monthlyStatsResult)
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    
}
