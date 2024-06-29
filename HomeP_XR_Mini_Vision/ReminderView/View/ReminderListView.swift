//
//  ReminderListView.swift
//  HomeP_XR_Mini_Vision
//
//  Created by 심재빈 on 6/29/24.
//

import SwiftUI
import EventKit

struct ReminderListView: View {
    @StateObject private var reminderViewModel = ReminderListViewModel()
    @State private var displayedReminders: [EKReminder] = []
    
    var body: some View {
        VStack {
            Text("Reminders")
                .font(.largeTitle)
                .padding()
            
            List(displayedReminders, id: \.self) { reminder in
                ReminderRow(reminder: reminder)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 8))
            }
            .frame(maxHeight: 350)
        }
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .onAppear {
            reminderViewModel.requestFullAccessToReminders { granted, error in
                if granted {
                    reminderViewModel.fetchAllReminders {
                        updateDisplayedReminders()
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
    }
    
    private func updateDisplayedReminders() {
        self.displayedReminders = reminderViewModel.reminders.filter { $0.dueDateComponents?.date ?? Date() > Date(timeIntervalSince1970: 0) } // Filter out reminders with invalid dates
        
//        // Debugging output
//        for reminder in self.displayedReminders {
//            print("Reminder: \(reminder.title), Due Date: \(reminder.dueDateComponents?.date)")
//        }
    }
}

struct ReminderRow: View {
    let reminder: EKReminder
    private let dateFormatter: DateFormatter

    init(reminder: EKReminder) {
        self.reminder = reminder
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy년 MM월 dd일 hh:mm a"
        self.dateFormatter.timeZone = TimeZone.current
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(reminder.title)
                .font(.headline)
                .fontWeight(.bold)
            
            if let dueDate = reminder.dueDateComponents?.date {
                Text(dateFormatter.string(from: dueDate))
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
