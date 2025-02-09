//
//  DetailViewModel.swift
//  DateSphere
//

import Foundation
import SwiftUI

// MARK: - DetailViewModel class

@MainActor
final class DetailViewModel: ObservableObject {

    // MARK: Dependencies

    private let getEventUseCase: GetEventUseCase?

    // MARK: Variables

    private let objectId: String
    @Published var event: EventDomainModel?
    @Published var error: Error?

    // MARK: Initializers

    init(objectId: String, useCase: GetEventUseCase) {
        self.getEventUseCase = useCase
        self.objectId = objectId
        setup()
    }

    init(event: EventDomainModel, useCase: GetEventUseCase?) {
        self.getEventUseCase = useCase
        self.objectId = event.objectId ?? event.id
        self.event = event
        setup()
    }

    // MARK: Methods

    func loadEvent(forceLoad: Bool = false) {

        // Ensure the event is not already loaded
        guard forceLoad || event == nil else { return }

        // Ensure the use case is available
        guard let getEventUseCase = self.getEventUseCase else {
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

}
