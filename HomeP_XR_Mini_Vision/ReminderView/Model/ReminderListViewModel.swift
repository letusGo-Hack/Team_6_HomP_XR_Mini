//
//  ReminderListViewModel.swift
//  HomeP_XR_Mini_Vision
//
//  Created by 심재빈 on 6/29/24.
//

import Foundation
import EventKit
import Combine

class ReminderListViewModel: ObservableObject {
    private let eventStore = EKEventStore()
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var reminders: [EKReminder] = []
    
    init() {
        NotificationCenter.default.publisher(for: .EKEventStoreChanged)
            .sink { [weak self] _ in
                self?.fetchAllReminders(completion: {})
            }
            .store(in: &cancellables)
    }
    
    func requestFullAccessToReminders(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestFullAccessToReminders { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }
    
    func fetchAllReminders(completion: @escaping () -> Void) {
        let calendars = eventStore.calendars(for: .reminder)
        let predicate = eventStore.predicateForReminders(in: calendars)
        
        eventStore.fetchReminders(matching: predicate) { reminders in
            DispatchQueue.main.async {
                self.reminders = reminders?.sorted(by: { $0.dueDateComponents?.date ?? Date() < $1.dueDateComponents?.date ?? Date() }) ?? []
                completion()
            }
        }
    }
}
