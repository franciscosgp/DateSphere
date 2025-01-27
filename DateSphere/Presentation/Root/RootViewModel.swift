//
//  RootViewModel.swift
//  DateSphere
//

import SwiftUI

// MARK: - RootViewModel class

@MainActor
final class RootViewModel: ObservableObject {

    // MARK: Coordinator

    unowned var coordinator: MainCoordinator

    // MARK: Dependencies

    let getEventsUseCase: GetEventsUseCase
    let deleteEventUseCase: DeleteEventUseCase

    // MARK: Variables

    @Published var loading: Bool = false
    @Published var events: [EventDomainModel] = []
    @Published var error: Error?

    // MARK: Initializers

    init(coordinator: MainCoordinator, getEventsUseCase: GetEventsUseCase, deleteEventUseCase: DeleteEventUseCase) {
        self.coordinator = coordinator
        self.getEventsUseCase = getEventsUseCase
        self.deleteEventUseCase = deleteEventUseCase
    }

    // MARK: Methods

    func loadEvents() {

        // Ensure that the action is not being executed
        guard loading == false else { return }
        loading = true

        // Prepare the use case
        let getEventsUseCase = getEventsUseCase

        // Get events
        Task(priority: .background) {
            do {
                let events = try await getEventsUseCase.execute()
                eventsLoaded(events: events ?? [])
            } catch {
                eventsLoadFailed(error: error)
            }
        }

    }

    func onAddButtonTapped() {
        coordinator.goToAddOrEditEvent()
    }

    func onEditButtonTapped(event: EventDomainModel) {
        coordinator.goToAddOrEditEvent(event: event)
    }

    func onDetailButtonTapped(event: EventDomainModel) {
        coordinator.goToDetail(event: event)
    }

    func onDeleteButtonTapped(event: EventDomainModel) {

        // Ensure that the action is not being executed
        guard loading == false else { return }
        loading = true

        // Prepare the use case
        let deleteEventUseCase = deleteEventUseCase

        // Delete the event
        Task(priority: .background) {
            do {
                try await deleteEventUseCase.execute(event)
                eventDeleted(event: event)
            } catch {
                eventsLoadFailed(error: error)
            }
        }

    }

    // MARK: Private methods

    private func eventsLoaded(events: [EventDomainModel]) {
        self.events = events
        self.loading = false
    }

    private func eventDeleted(event: EventDomainModel) {
        self.events = events.filter { $0 != event }
        self.loading = false
    }

    private func eventsLoadFailed(error: Error) {
        self.error = error
        self.loading = false
    }

}
