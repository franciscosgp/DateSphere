//
//  DeleteEventUseCase.swift
//  DateSphere
//

final class DeleteEventUseCase: BaseUseCase<EventDomainModel, Void> {

    // MARK: Variables

    private let eventRepository: EventRepository

    // MARK: Initializers

    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository
        super.init()
    }

    // MARK: Methods

    override func handle(input: EventDomainModel? = nil) async throws {
        guard let input = input else { return }
        return try await eventRepository.deleteEvent(input)
    }

}
