//
//  EventsView.swift
//  Event Countdown
//
//  Created by Almoutasem on 14/06/2024.
//

import SwiftUI

struct EventsView: View {
    @State private var events: [Event] = []
    @State private var showingAddEvent = false
    @State private var selectedEvent: Event?

    var body: some View {
        NavigationStack {
            List {
                ForEach(events) { event in
                    NavigationLink(destination: EventForm(event: event, onSave: { updatedEvent in
                        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
                            events[index] = updatedEvent
                        }
                        saveEvents()
                    })) {
                        EventRow(event: event)
                    }
                }
                .onDelete(perform: deleteEvent)
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EventForm(event: Event(id: UUID(), title: "", date: Date(), textColor: .black), onSave: { newEvent in
                        events.append(newEvent)
                        events.sort()
                        saveEvents()
                    })) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear(perform: loadEvents)
        }
    }

    private func deleteEvent(at offsets: IndexSet) {
        events.remove(atOffsets: offsets)
        saveEvents()
    }

    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: "events")
        }
    }

    private func loadEvents() {
        if let savedEvents = UserDefaults.standard.data(forKey: "events") {
            if let decodedEvents = try? JSONDecoder().decode([Event].self, from: savedEvents) {
                events = decodedEvents
            }
        }
    }
}
