//
//  AddOrUpdateEventUseCase.swift
//  DateSphere
//

// MARK: - AddOrUpdateEventUseCase class

final class AddOrUpdateEventUseCase: BaseUseCase<EventDomainModel, EventDomainModel> {

    // MARK: Variables

    private let eventRepository: EventRepository

    // MARK: Initializers

    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository
        super.init()
    }

    // MARK: Methods

    override func handle(input: EventDomainModel? = nil) async throws -> EventDomainModel? {
        guard let input = input else { return nil }
        return try await eventRepository.addOrUpdateEvent(input)
    }

}
