//
//  EventDataSource.swift
//  DateSphere
//

import Foundation
@preconcurrency import ParseSwift

// MARK: - EventDataSource actor

final actor EventDataSource: EventRepository {

    // MARK: Methods

    func getEvents() async throws -> [EventDomainModel] {
        try await NetworkMonitor.shared.checkNetworkConnection()
        return try await EventDataModel.query()
            .order([.ascending("date")])
            .find()
            .map { try $0.parseToDomainModel() }
    }

    func getEvent(by objectId: String) async throws -> EventDomainModel {
        try await NetworkMonitor.shared.checkNetworkConnection()
        return try await EventDataModel(objectId: objectId)
            .fetch()
            .parseToDomainModel()
    }

    func addOrUpdateEvent(_ event: EventDomainModel) async throws -> EventDomainModel {
        try await NetworkMonitor.shared.checkNetworkConnection()
        if event.objectId == nil {
            return try await EventDataModel(with: event)
                .save()
                .parseToDomainModel()
        } else {
            return try await EventDataModel(objectId: event.objectId)
                .fetch()
                .merge(with: event)
                .save()
                .parseToDomainModel()
        }
    }

    func deleteEvent(_ event: EventDomainModel) async throws {
        try await NetworkMonitor.shared.checkNetworkConnection()
        try await EventDataModel(objectId: event.objectId)
            .delete()
    }

}
