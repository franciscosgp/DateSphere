//
//  GetEventUseCase.swift
//  DateSphere
//

// MARK: - GetEventUseCase class

final class GetEventUseCase: BaseUseCase<String, EventDomainModel> {

    // MARK: Variables

    private let eventRepository: EventRepository

    // MARK: Initializers

    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository
        super.init()
    }

    // MARK: Methods

    override func handle(input: String? = nil) async throws -> EventDomainModel? {
        guard let input = input else { return nil }
        return try await eventRepository.getEvent(by: input)
    }

}
