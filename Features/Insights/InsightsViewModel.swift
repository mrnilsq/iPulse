// InsightsViewModel.swift
import SwiftUI
import Combine
import HealthKit

class InsightsViewModel: ObservableObject {
    @Published var selectedPeriod: TimePeriod = .week
    @Published var activitySummary: ActivitySummary?
    @Published var topActivities: [ActivityDetail] = []
    @Published var performanceInsights: [PerformanceInsight] = []
    @Published var weeklyHealthMetrics: DailyMetrics? // Changed to DailyMetrics
    @Published var error: Error?
    @Published var isLoading = false
    
    private let healthKitManager: HealthKitManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(healthKitManager: HealthKitManager = .shared) {
        self.healthKitManager = healthKitManager
    }
    
    enum TimePeriod: String, CaseIterable, Identifiable {
        case week, month, year
        var id: String { self.rawValue }
    }
    
    func startFetchingData() {
        fetchData()
        //setup background refresh
    }
    
    func stopFetchingData() {
        cancellables.removeAll()
    }
    
    @MainActor
    func fetchData() async {
        isLoading = true
        error = nil
        
        let startDate: Date
        switch selectedPeriod {
        case .week:
            startDate = Date().startOfWeek
        case .month:
            startDate = Date().startOfMonth
        case .year:
            startDate = Date().startOfYear
        }
        
        async let activitySummaryResult = healthKitManager.getActivitySummary(startDate: startDate, endDate: Date())
        async let topActivitiesResult = healthKitManager.getTopActivities(startDate: startDate, endDate: Date())
        async let performanceInsightsResult = healthKitManager.getPerformanceInsights(startDate: startDate, endDate: Date())
        async let weeklyHealthMetricsResult = healthKitManager.getDailyMetrics(startDate: startDate, endDate: Date()) //changed
        
        do {
            (activitySummary, topActivities, performanceInsights, weeklyHealthMetrics) = try await (activitySummaryResult, topActivitiesResult, performanceInsightsResult, weeklyHealthMetricsResult)
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}
