//
//  DetailViewModel.swift
//  DateSphere
//

import Foundation
import SwiftUI

// MARK: - DetailViewModel class

@MainActor
final class DetailViewModel: ObservableObject {

    // MARK: Use cases

    struct UseCases {
        let getEventUseCase: GetEventUseCase
        let addOrUpdateEventUseCase: AddOrUpdateEventUseCase
    }

    // MARK: Dependencies

    private let useCases: UseCases?

    // MARK: Variables

    private let objectId: String
    @Published var event: EventDomainModel?
    @Published var error: Error?

    @Published var isUpdating: Bool = false
    @Published var updatingError: Error?
    let saveAction: ((EventDomainModel) -> Void)?

    var disableMinusAction: Bool {
        guard !isUpdating, let event else { return true }
        return event.counter <= 0
    }

    var disablePlusAction: Bool {
        guard !isUpdating, let event else { return true }
        return event.counter >= 1000
    }

    // MARK: Initializers

    init(objectId: String, useCases: UseCases, saveAction: ((EventDomainModel) -> Void)?) {
        self.useCases = useCases
        self.objectId = objectId
        self.saveAction = saveAction
        setup()
    }

    init(event: EventDomainModel, useCases: UseCases?, saveAction: ((EventDomainModel) -> Void)?) {
        self.useCases = useCases
        self.objectId = event.objectId ?? event.id
        self.event = event
        self.saveAction = saveAction
        setup()
    }

    // MARK: Methods

    func loadEvent(forceLoad: Bool = false) {

        // Ensure the event is not already loaded
        guard forceLoad || event == nil else { return }

        // Ensure the use case is available
        guard let getEventUseCase = self.useCases?.getEventUseCase else {
            self.error = DetailError.requireUseCase
            return
        }

        // Prepare objectId in environment
        let objectId = event?.objectId ?? objectId

        // Reset error state
        error = nil

        // Load the event
        Task(priority: .background) { [weak self] in
            do {
                let event = try await getEventUseCase.execute(objectId)
                self?.eventLoaded(event: event)
            } catch {
                self?.eventLoadFailed(error: error)
            }
        }

    }

    func updateCounter(withIncrement increment: Double) {

        // Ensure the use case is available
        guard let addOrUpdateEventUseCase = self.useCases?.addOrUpdateEventUseCase else {
            self.error = DetailError.requireUseCase
            return
        }

        // Ensure event
        guard var event = event else {
            return
        }

        // Ensure that the action is not being executed
        guard isUpdating == false else { return }
        isUpdating = true

        // Update counter
        event.counter += increment

        // Update the event
        Task(priority: .background) { [weak self] in
            do {
                let newEvent = try await addOrUpdateEventUseCase.execute(event)
                self?.eventUpdated(event: newEvent)
            } catch {
                self?.eventUpdateFailed(error: error)
            }
        }

    }

    // MARK: Private methods

    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: .notificationReceived, object: nil)
    }

    @objc func notificationReceived(_ notification: Notification) {
        if let eventObjectId = (notification.object as?[AnyHashable: Any])?[Constants.NotificationFields.eventId] as? String,
           (event?.objectId ?? objectId) == eventObjectId {
            loadEvent(forceLoad: true)
        }
    }

    private func eventLoaded(event: EventDomainModel?) {
        self.event = event
    }

    private func eventLoadFailed(error: Error) {
        self.error = error
    }

    private func eventUpdated(event: EventDomainModel?) {
        self.event = event
        isUpdating = false
        if let event {
            saveAction?(event)
        }
    }

    private func eventUpdateFailed(error: Error) {
        updatingError = error
        isUpdating = false
    }

}
