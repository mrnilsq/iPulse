// EmptyStateView.swift
import SwiftUI

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack {
            Text("🏋️")
                .font(.system(size: 80)) // Use a large SF Symbol
                .padding()
            Text(message)
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.05))
    }
}
