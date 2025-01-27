//
//  EventRepository.swift
//  DateSphere
//

// MARK: - EventRepository protocol

protocol EventRepository {

    // MARK: Methods

    func getEvents() async throws -> [EventDomainModel]
    func addOrUpdateEvent(_ event: EventDomainModel) async throws -> EventDomainModel
    func deleteEvent(_ event: EventDomainModel) async throws

}
