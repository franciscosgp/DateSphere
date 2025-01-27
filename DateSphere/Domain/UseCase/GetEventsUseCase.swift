//
//  GetEventsUseCase.swift
//  DateSphere
//

// MARK: - GetEventsUseCase class

final class GetEventsUseCase: BaseUseCase<Void, [EventDomainModel]> {

    // MARK: Variables

    private let eventRepository: EventRepository

    // MARK: Initializers

    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository
        super.init()
    }

    // MARK: Methods

    override func handle(input: Void? = nil) async throws -> [EventDomainModel]? {
        return try await eventRepository.getEvents()
    }

}
