//
//  EventRow.swift
//  Event Countdown
//
//  Created by Almoutasem on 14/06/2024.
//

import SwiftUI

import SwiftUI

struct EventRow: View {
    let event: Event
    @State private var timeRemaining: String = ""

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .foregroundColor(event.textColor)
                .font(.title)
            Text(timeRemaining)
                .onReceive(timer) { _ in
                    updateTimeRemaining()
                }
        }
    }

    private func updateTimeRemaining() {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        timeRemaining = formatter.localizedString(for: event.date, relativeTo: Date())
    }
}
