// ActivitiesListView.swift
import SwiftUI

struct ActivitiesListView: View {
    let activities: [ActivityDetail]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Activities")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            if activities.isEmpty {
                Text("No activities recorded")
                    .foregroundColor(.gray)
            } else {
                ForEach(activities) { activity in
                    ActivityCardView(activity: activity)
                        .padding(.bottom, 8)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}
