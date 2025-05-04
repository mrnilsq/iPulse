// AppState.swift
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var healthKitManager = HealthKitManager.shared
    @Published var error: Error?
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        // Request HealthKit authorization when AppState is initialized
        requestHealthKitAuthorization()
    }
    
    func requestHealthKitAuthorization() {
        Task {
            await healthKitManager.requestAuthorization()
        }
        
        healthKitManager.$healthKitAuthorizationDenied
            .drop(while: { $0 == false }) //ignore the first initial value
            .sink { [weak self] denied in
                if denied {
                    // Handle the denial, e.g., show an alert
                    self?.error = HealthKitError.unauthorized
                }
            }
            .store(in: &cancellables)
    }
}
