// AppCoordinator.swift
import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var currentTab: Tab = .home
    @Published var healthKitAuthorizationDenied = false
    @Published var error: Error?
    @Published var isLoading = false // Added loading state for initial data loading
    
    // Using an enum for tab management is more robust and type-safe
    enum Tab {
        case home, insights, goals
    }
    
    func showHealthKitDeniedAlert() {
        healthKitAuthorizationDenied = true
    }
    
    func showErrorAlert(error: Error) {
        self.error = error
    }
    
    @ViewBuilder
    func showCurrentView() -> some View {
        switch currentTab {
        case .home:
            HomeView()
        case .insights:
            InsightsView()
        case .goals:
            GoalsView()
        }
    }
}

struct AppCoordinatorView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            if coordinator.isLoading {
                LoadingView() // Show loading view during initial setup
            } else if coordinator.healthKitAuthorizationDenied {
                HealthKitPermissionView() // Show HealthKit permission denial view
            } else if let error = coordinator.error {
                ErrorView(error: error) { // Show error view with retry option
                    //  Attempt to reload data or re-authorize HealthKit.
                    coordinator.isLoading = true //set to true before the action that might take time
                    Task {
                       //reload data
                        coordinator.isLoading = false
                    }
                }
            } else {
                coordinator.showCurrentView() // Show the main content
            }
            
            // Bottom navigation bar
            VStack {
                Spacer()
                HStack {
                    tabButton(tab: .home, label: "Home", systemImage: "house.fill")
                    tabButton(tab: .insights, label: "Insights", systemImage: "chart.bar.fill")
                    tabButton(tab: .goals, label: "Goals", systemImage: "target")
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .background(Color.gray.opacity(0.1)) // Background for the tab bar
                .cornerRadius(10)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .alert(isPresented: $coordinator.healthKitAuthorizationDenied) { //error alert
            Alert(
                title: Text("HealthKit Required"),
                message: Text("HealthKit permissions are required for iPulse to function properly. Please enable permissions in Settings."),
                primaryButton: .default(Text("Settings"), action: {
                    // Open app settings.  Important to use UIApplication.open
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }),
                secondaryButton: .cancel()
            )
        }
        .alert(item: $coordinator.error) { error in //another error alert
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK")) {
                    coordinator.error = nil // Clear the error after it's been shown
                }
            )
        }
        .onAppear { // Perform initial setup when the view appears
            coordinator.isLoading = true //start loading
            Task {
                // Perform any initial data loading or HealthKit setup here.
                // For example:
                // await healthKitManager.requestAuthorization()
                // await loadInitialData()
                
                // Simulate loading delay
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                coordinator.isLoading = false //stop loading
                
            }
        }
    }
    
    // Tab button for the bottom navigation
    func tabButton(tab: AppCoordinator.Tab, label: String, systemImage: String) -> some View {
        Button(action: {
            coordinator.currentTab = tab
        }) {
            VStack {
                Image(systemName: systemImage)
                    .font(.headline)
                Text(label)
                    .font(.caption)
            }
            .foregroundColor(coordinator.currentTab == tab ? .blue : .gray) // Highlight selected tab
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
        }
    }
}
struct AppCoordinator: View {
    @StateObject var coordinator = AppCoordinator()
    var body: some View{
        AppCoordinatorView(coordinator: coordinator)
    }
}
