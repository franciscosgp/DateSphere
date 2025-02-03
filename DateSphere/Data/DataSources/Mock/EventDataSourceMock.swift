//
//  EventDataSourceMock.swift
//  DateSphere
//

import Foundation
import SwiftUICore

#if DEBUG

// MARK: - DetailError enum

enum EventDataSourceMockError: AppError {

    // MARK: Cases

    case noExist

    // MARK: Variables

    var description: String {
        switch self {
        case .noExist:
            return "The event does not exist"
        }
    }

}

// MARK: - EventDataSourceMock actor

final actor EventDataSourceMock: EventRepository {

    // MARK: Variables

    var mockEvents: [EventDomainModel] = [
        .init(objectId: "0", name: "Event 1", description: "Event description 1", iconName: "rublesign.square", mainColor: .brown, secondaryColor: .clear, backgroundColor: .yellow, date: Date(timeIntervalSinceNow: 10_000_000)),
        .init(objectId: "1", name: "Event 2", description: "Event description 2", iconName: "hand.tap", mainColor: .red, secondaryColor: .clear, backgroundColor: .orange, date: Date(timeIntervalSinceNow: -10_000_000)),
        .init(objectId: "2", name: "Event 3", description: "Event description 3", iconName: "hifispeaker.and.homepod.fill", mainColor: .blue, secondaryColor: .clear, backgroundColor: .pink, date: Date(timeIntervalSinceNow: 5_000_000)),
        .init(objectId: "3", name: "Event 4", description: "Event description 4", iconName: "headphones", mainColor: .cyan, secondaryColor: .clear, backgroundColor: .gray, date: Date())
    ]

    var randomDelay: UInt64 {
        return UInt64(Double.random(in: 0.5...2.0) * 1_000_000_000)
    }

    // MARK: Methods

    func getEvents() async throws -> [EventDomainModel] {
        try? await Task.sleep(nanoseconds: randomDelay)
        return mockEvents.sorted(by: { $0.date < $1.date })
    }

    func getEvent(by objectId: String) async throws -> EventDomainModel {
        try? await Task.sleep(nanoseconds: randomDelay)
        if let event = mockEvents.first(where: { $0.objectId == objectId }) {
            return event
        } else {
            throw EventDataSourceMockError.noExist
        }
    }

    func addOrUpdateEvent(_ event: EventDomainModel) async throws -> EventDomainModel {
        try? await Task.sleep(nanoseconds: randomDelay)
        if event.objectId == nil {
            let newEvent = EventDomainModel(
                objectId: UUID().uuidString,
                name: event.name,
                description: event.description,
                iconName: event.iconName,
                mainColor: event.mainColor,
                secondaryColor: event.secondaryColor,
                backgroundColor: event.backgroundColor,
                date: event.date
            )
            mockEvents.append(newEvent)
            return newEvent
        } else if let index = mockEvents.firstIndex(where: { $0.objectId == event.objectId }) {
            mockEvents[index] = event
            return event
        } else {
            mockEvents.append(event)
            return event
        }
    }

    func deleteEvent(_ event: EventDomainModel) async throws {
        try? await Task.sleep(nanoseconds: randomDelay)
        mockEvents.removeAll(where: { $0.objectId == event.objectId })
    }

}

#endif
