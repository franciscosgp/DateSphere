//
//  ListViewModel.swift
//  DateSphere
//


import SwiftUI
import UIKit
import UserNotifications

// MARK: - ListViewModel class

@MainActor
final class ListViewModel: ObservableObject {

    // MARK: Use cases

    struct UseCases {
        let getEventsUseCase: GetEventsUseCase
        let deleteEventUseCase: DeleteEventUseCase
    }

    // MARK: Actions

    struct Actions {
        typealias ConfirmationHandler = ((EventDomainModel) -> Void)?
        let addEvent: (ConfirmationHandler) -> Void
        let viewEvent: (EventDomainModel) -> Void
        let editEvent: (EventDomainModel, ConfirmationHandler) -> Void
    }

    // MARK: Dependencies

    private let useCases: UseCases
    private let actions: Actions

    // MARK: Variables

    @Published var showLoading: Bool = false
    @Published var loading: Bool = false {
        didSet {
            if loading == false {
                showLoading = false
            }
        }
    }
    @Published var events: [EventDomainModel]
    @Published var error: Error?
    @Published var showRemoveConfirmation: Bool = false
    @Published var eventToRemove: EventDomainModel?

    var removeAlertMessage: String {
        String(format: "alert_delete_title".localized, eventToRemove?.name ?? "event".localized)
    }

    // MARK: Initializers

    init(useCases: UseCases,
         actions: Actions) {
        self.events = []
        self.useCases = useCases
        self.actions = actions
        Task {
            await self.loadEvents()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: .notificationReceived, object: nil)
    }

    // MARK: Methods

    func loadEvents(showLoading: Bool = true) async {

        // Ensure that the action is not being executed
        guard loading == false else { return }
        loading = true
        self.showLoading = showLoading

        // Prepare the use case
        let getEventsUseCase = useCases.getEventsUseCase

        // Get events
        await Task(priority: .background) {
            do {
                let events = try await getEventsUseCase.execute()
                eventsLoaded(events: events ?? [])
            } catch {
                eventsLoadFailed(error: error)
            }
        } .value

    }

    func onAddButtonTapped() {
        actions.addEvent { [weak self] event in
            self?.eventAdded(event: event)
        }
    }

    func onEditButtonTapped(event: EventDomainModel) {
        actions.editEvent(event) { [weak self] event in
            self?.eventUpdated(event: event)
        }
    }

    func onDetailButtonTapped(event: EventDomainModel) {
        actions.viewEvent(event)
    }

    func onDeleteButtonTapped(event: EventDomainModel) {
        eventToRemove = event
        showRemoveConfirmation.toggle()
    }

    func onDeleteConfirmButtonTapped() {

        // Ensure event to remove is not nil
        guard let event = eventToRemove else { return }

        // Ensure that the action is not being executed
        guard loading == false else { return }
        loading = true
        showLoading = true

        // Prepare the use case
        let deleteEventUseCase = useCases.deleteEventUseCase

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

    func clearState() {
        loading = false
        error = nil
        showRemoveConfirmation = false
        eventToRemove = nil
    }

    // MARK: Private methods

    @objc func notificationReceived(_ notification: Notification) {
        if let eventObjectId = (notification.object as?[AnyHashable: Any])?[Constants.NotificationFields.eventId] as? String,
           !AppDelegate.shared.isLastActionPerfomedByUser(for: eventObjectId) {
            Task {
                await loadEvents(showLoading: false)
            }
        }
    }

    private func eventsLoaded(events: [EventDomainModel]) {
        self.events = events
        self.loading = false
    }

    private func eventAdded(event: EventDomainModel) {
        events = (events + [event]).sorted(by: { $0.date < $1.date })
        self.loading = false
        AppDelegate.shared.updateLastAction(event: event)
    }

    private func eventUpdated(event: EventDomainModel) {
        self.events = events.map { $0.objectId == event.objectId ? event : $0 }.sorted(by: { $0.date < $1.date })
        self.loading = false
        AppDelegate.shared.updateLastAction(event: event)
    }

    private func eventDeleted(event: EventDomainModel) {
        self.events = events.filter { $0 != event }
        self.loading = false
        AppDelegate.shared.updateLastAction(event: event)
    }

    private func eventsLoadFailed(error: Error) {
        self.error = error
        self.loading = false
    }

}
