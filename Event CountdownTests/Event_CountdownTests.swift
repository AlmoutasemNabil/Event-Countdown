//
//  Event_CountdownTests.swift
//  Event CountdownTests
//
//  Created by Almoutasem on 14/06/2024.
//

import XCTest
import SwiftUI
@testable import Event_Countdown

final class Event_CountdownTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        UserDefaults.standard.removeObject(forKey: "events")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserDefaults.standard.removeObject(forKey: "events")
    }

    func testEventEncodingDecoding() throws {
        // Given
        let originalEvent = Event(id: UUID(), title: "Test Event", date: Date(), textColor: .red)

        // When
        let encodedData = try JSONEncoder().encode(originalEvent)
        let decodedEvent = try JSONDecoder().decode(Event.self, from: encodedData)

        // Then
        XCTAssertEqual(originalEvent.id, decodedEvent.id)
        XCTAssertEqual(originalEvent.title, decodedEvent.title)
        XCTAssertEqual(originalEvent.date, decodedEvent.date)
        XCTAssertEqual(originalEvent.textColor.toUIColor(), decodedEvent.textColor.toUIColor())
    }

    func testSavingEventsToUserDefaults() throws {
        // Given
        let events = [
            Event(id: UUID(), title: "Event 1", date: Date(), textColor: .blue),
            Event(id: UUID(), title: "Event 2", date: Date().addingTimeInterval(1000), textColor: .green)
        ]

        // When
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: "events")
        }

        // Then
        if let savedEventsData = UserDefaults.standard.data(forKey: "events"),
           let savedEvents = try? JSONDecoder().decode([Event].self, from: savedEventsData) {
            XCTAssertEqual(events.count, savedEvents.count)
            XCTAssertEqual(events[0].title, savedEvents[0].title)
            XCTAssertEqual(events[1].title, savedEvents[1].title)
        } else {
            XCTFail("Failed to save and load events")
        }
    }

    func testLoadingEventsFromUserDefaults() throws {
        // Given
        let events = [
            Event(id: UUID(), title: "Event 1", date: Date(), textColor: .blue),
            Event(id: UUID(), title: "Event 2", date: Date().addingTimeInterval(1000), textColor: .green)
        ]

        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: "events")
        }

        // When
        var loadedEvents: [Event] = []
        if let savedEventsData = UserDefaults.standard.data(forKey: "events"),
           let savedEvents = try? JSONDecoder().decode([Event].self, from: savedEventsData) {
            loadedEvents = savedEvents
        }

        // Then
        XCTAssertEqual(events.count, loadedEvents.count)
        XCTAssertEqual(events[0].title, loadedEvents[0].title)
        XCTAssertEqual(events[1].title, loadedEvents[1].title)
    }

    func testPerformanceExample() throws {
        self.measure {
            // Measure the performance of encoding and decoding a large number of events
            let events = (0..<1000).map { Event(id: UUID(), title: "Event \($0)", date: Date(), textColor: .red) }
            do {
                let encodedData = try JSONEncoder().encode(events)
                _ = try JSONDecoder().decode([Event].self, from: encodedData)
            } catch {
                XCTFail("Performance test failed with error: \(error)")
            }
        }
    }
}

private extension Color {
    func toUIColor() -> UIColor {
        let components = self.cgColor?.components
        return UIColor(red: components?[0] ?? 0,
                       green: components?[1] ?? 0,
                       blue: components?[2] ?? 0,
                       alpha: components?[3] ?? 1)
    }
}
