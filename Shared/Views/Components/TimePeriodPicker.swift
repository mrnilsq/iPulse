// TimePeriodPicker.swift
import SwiftUI

struct TimePeriodPicker: View {
    @Binding var selectedPeriod: TimePeriod
    
    enum TimePeriod: String, CaseIterable, Identifiable {
        case week, month, year
        var id: String { self.rawValue }
    }
    
    var body: some View {
        HStack {
            ForEach(TimePeriod.allCases) { period in
                Button(action: {
                    selectedPeriod = period
                }) {
                    Text(period.rawValue.capitalized)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .foregroundColor(selectedPeriod == period ? .white : .gray)
                        .background(selectedPeriod == period ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
    }
}
