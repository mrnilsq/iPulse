// HealthKitPermissionView.swift
import SwiftUI

struct HealthKitPermissionView: View {
    var body: some View {
        VStack {
            Text("HealthKit Permissions Required")
                .font(.title)
                .foregroundColor(.red)
                .padding()
            
            Text("Please enable HealthKit permissions in Settings to use iPulse.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Go to Settings") {
                // Open the app settings where the user can enable HealthKit permissions
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.05))
    }
}
