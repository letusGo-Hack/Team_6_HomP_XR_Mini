//
//  CalendarEventListView.swift
//  HomeP_XR_Mini
//
//  Created by 심재빈 on 6/29/24.
//

import SwiftUI
import EventKit

struct CalendarEventListView: View {
    @StateObject private var calendarViewModel = CalendarEventListViewModel()
    @State private var displayedEvents: [EKEvent] = []
    
    var body: some View {
        VStack {
            Text("Calendar Events")
                .font(.largeTitle)
                .padding()
            
            List(displayedEvents, id: \.self) { event in
                EventRow(event: event)
                    .frame(maxWidth: .infinity)
//                    .cornerRadius(8)
//                    .shadow(radius: 4)
//                    .padding(.horizontal)
//                    .padding(.vertical, 4)
//                    .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 8))
            }
//            .frame(maxHeight: 350)
        }
//        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .onAppear {
            calendarViewModel.requestFullAccessToEvents { granted, error in
                if granted {
                    calendarViewModel.fetchAllEvents {
                        updateDisplayedEvents()
                    }
                } else {
                    if let error = error {
                        print("Access denied: \(error.localizedDescription)")
                    } else {
                        print("Access denied")
                    }
                }
            }
        }
        .glassBackgroundEffect()
    }
    
    private func updateDisplayedEvents() {
        self.displayedEvents = calendarViewModel.events.filter { $0.startDate > Date(timeIntervalSince1970: 0) } // Filter out events with invalid dates
        
//        // Debugging output
//        for event in self.displayedEvents {
//            print("Event: \(event.title), Start Date: \(event.startDate)")
//        }
    }
}

struct EventRow: View {
    let event: EKEvent
    private let dateFormatter: DateFormatter

    init(event: EKEvent) {
        self.event = event
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy년 MM월 dd일 hh:mm a"
        self.dateFormatter.timeZone = TimeZone.current
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(event.title)
                .font(.headline)
                .fontWeight(.bold)
            
            if let location = event.location {
                Text(location)
                    .font(.subheadline)
            }
            
            Text(dateFormatter.string(from: event.startDate))
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .padding()
    }
}
