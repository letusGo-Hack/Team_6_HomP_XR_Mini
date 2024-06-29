//
//  CalendarEventListViewModel.swift
//  HomeP_XR_Mini_Vision
//
//  Created by 심재빈 on 6/29/24.
//

import Foundation
import EventKit

class CalendarEventListViewModel: ObservableObject {
    private let eventStore = EKEventStore()
    
    @Published var events: [EKEvent] = []
    
    func requestFullAccessToEvents(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestFullAccessToEvents { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }
    
    func fetchAllEvents(completion: @escaping () -> Void) {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: -1, to: Date())!
        let endDate = calendar.date(byAdding: .month, value: 1, to: Date())!
        
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        DispatchQueue.global().async {
            let events = self.eventStore.events(matching: predicate)
            DispatchQueue.main.async {
                self.events = events.sorted(by: { $0.startDate > $1.startDate })
                completion()
            }
        }
    }
}
