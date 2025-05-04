// RefreshCoordinator.swift
import Foundation
import Combine

class RefreshCoordinator: ObservableObject {
    @Published var shouldRefresh = false
    private var cancellables: Set<AnyCancellable> = []
    
    // You can use this publisher to trigger refreshes from anywhere in your app
    static let refreshPublisher = PassthroughSubject<Void, Never>()
    
    init() {
        // Subscribe to the refresh publisher and update the shouldRefresh property
        RefreshCoordinator.refreshPublisher
            .sink { [weak self] in
                self?.shouldRefresh = true // Set to true to trigger refresh
                // Optionally, reset it after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { //short delay
                    self?.shouldRefresh = false //set back to false
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

// Extension for calculating averages
extension Collection where Element: Numeric {
    func average() -> Element? {
        isEmpty ? nil : self.reduce(0, +) / Element.init(count)
    }
}

// Extension for TimeInterval formatting
extension TimeInterval {
    func formatted() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .drop
        return formatter.string(from: self) ?? "0s"
    }
}
