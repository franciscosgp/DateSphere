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
    }

    init(event: EventDomainModel) {
        self.getEventUseCase = nil
        self.objectId = event.objectId ?? event.id
        self.event = event
    }

    // MARK: Methods

    func loadEvent() {

        // Ensure the event is not already loaded
        guard event == nil else { return }

        // Ensure the use case is available
        guard let getEventUseCase = self.getEventUseCase else {
            self.error = DetailError.requireUseCase
            return
        }

        // Prepare objectId in environment
        let objectId = objectId

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

    private func eventLoaded(event: EventDomainModel?) {
        self.event = event
    }

    private func eventLoadFailed(error: Error) {
        self.error = error
    }

}
