// iPulseApp.swift
import SwiftUI

@main
struct iPulseApp: App {
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            AppCoordinator()
                .environmentObject(appState)
        }
    }
}



















        
        

        

        

        
