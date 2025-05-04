// HomeView.swift
import SwiftUI
import HealthKit

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                StatusBarSection(dailyMetrics: viewModel.dailyMetrics)
                    .padding(.bottom)
                
                WorkoutsSection(workouts: viewModel.recentWorkouts)
                    .padding(.bottom)
                
                ActivityPulseSection(weeklyStats: viewModel.weeklyStats, monthlyStats: viewModel.monthlyStats)
                
                Spacer() // Add spacer to push content to the top
            }
            .padding()
        }
        .background(Color.white.opacity(0.05)) // Subtle background
        .navigationTitle("Home")
        .refreshable { //refresh action
            await viewModel.fetchData()
        }
        .onAppear {
            viewModel.startFetchingData() // start fetching data
        }
        .onDisappear{
            viewModel.stopFetchingData() //stop fetching data
        }
        .alert(item: $viewModel.error) { error in  //display error
            Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
        }
    }
}
