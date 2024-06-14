//
//  EventForm.swift
//  Event Countdown
//
//  Created by Almoutasem on 14/06/2024.
//
import SwiftUI

struct EventForm: View {
    enum Mode {
        case add
        case edit
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var event: Event
    private var onSave: (Event) -> Void
    private var mode: Mode
    private var initialTitle: String

    init(event: Event, onSave: @escaping (Event) -> Void) {
        self._event = State(initialValue: event)
        self.onSave = onSave
        self.mode = event.title.isEmpty ? .add : .edit
        self.initialTitle = event.title
    }

    var body: some View {
        Form {
            Section(header: Text("Event Details")) {
                TextField("Title", text: $event.title)
                DatePicker("Date", selection: $event.date, displayedComponents: [.date, .hourAndMinute])
                ColorPicker("Text Color", selection: $event.textColor)
            }
        }
        .navigationTitle(mode == .add ? "Add Event" : "Edit \(initialTitle)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if !event.title.isEmpty {
                        onSave(event)
                        dismiss()
                    }
                }) {
                    Image(systemName: "checkmark")
                }
                .disabled(event.title.isEmpty)
            }
        }
    }
}
