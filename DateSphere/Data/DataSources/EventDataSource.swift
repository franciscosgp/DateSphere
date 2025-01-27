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
        return try await EventDataModel.query()
            .order([.ascending("date")])
            .find()
            .map { try $0.parseToDomainModel() }
    }

    func addOrUpdateEvent(_ event: EventDomainModel) async throws -> EventDomainModel {
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
        try await EventDataModel(objectId: event.objectId)
            .delete()
    }

}
