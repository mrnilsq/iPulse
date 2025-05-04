// ErrorView.swift
import SwiftUI

struct ErrorView: View {
    let error: Error
    let onRetry: () -> Void  // Closure for the retry action
    
    var body: some View {
        VStack {
            Text("Error")
                .font(.title)
                .foregroundColor(.red)
            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(.gray)
                .padding()
            
            Button("Retry") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.05))
    }
}
