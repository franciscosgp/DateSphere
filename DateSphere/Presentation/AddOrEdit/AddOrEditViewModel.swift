//
//  AddOrEditViewModel.swift
//  DateSphere
//

import Foundation
import SwiftUI

// MARK: - AddOrEditViewModel class

@MainActor
final class AddOrEditViewModel: ObservableObject {

    // MARK: Coordinator

    unowned var coordinator: any Coordinator

    // MARK: Dependencies

    private let addOrUpdateEventUseCase: AddOrUpdateEventUseCase

    // MARK: Variables

    @Published var name: String = ""
    @Published var description: String = ""
    @Published var iconName: String? = nil
    @Published var foregroundColor: Color = .accentColor
    @Published var backgroundColor: Color = .gray.opacity(0.2)
    @Published var date: Date = Date()

    @Published var loading: Bool = false
    @Published var success: Bool = false
    @Published var error: Error?
    var event: EventDomainModel?

    // MARK: Initializers

    init(coordinator: any Coordinator, event: EventDomainModel?, useCase: AddOrUpdateEventUseCase) {
        self.coordinator = coordinator
        self.addOrUpdateEventUseCase = useCase
        self.event = event
        loadEvent()
    }

    // MARK: Methods

    func loadEvent() {
        if let event = event {
            name = event.name
            description = event.description ?? ""
            iconName = event.iconName ?? ""
            foregroundColor = event.foregroundColor ?? .accentColor
            backgroundColor = event.backgroundColor ?? .gray.opacity(0.2)
            date = event.date
        }
    }

    func addOrUpdateEvent() {

        // Ensure that the name is not empty
        guard !name.isEmpty else {
            return eventAddOrUpdateFailed(error: AddOrEditError.empty(parameter: "name"))
        }

        // Ensure that the icon is not empty
        guard let iconName, !iconName.isEmpty else {
            return eventAddOrUpdateFailed(error: AddOrEditError.empty(parameter: "icon"))
        }

        // Ensure that the action is not being executed
        guard loading == false else { return }
        loading = true

        // Create the event and the use case
        let addOrUpdateEventUseCase = addOrUpdateEventUseCase
        let event = EventDomainModel(
            objectId: event?.objectId,
            name: name,
            description: description.isEmpty ? nil : description,
            iconName: iconName,
            foregroundColor: foregroundColor.isFullyTransparent ? nil : foregroundColor,
            backgroundColor: backgroundColor.isFullyTransparent ? nil : backgroundColor,
            date: date
        )

        // Add or update the event
        Task(priority: .background) { [weak self] in
            do {
                let newEvent = try await addOrUpdateEventUseCase.execute(event)
                self?.eventAddedOrUpdated(event: newEvent)
            } catch {
                self?.eventAddOrUpdateFailed(error: error)
            }
        }

    }

    func cleanError() {
        error = nil
    }

    // MARK: Private methods

    private func eventAddedOrUpdated(event: EventDomainModel?) {
        self.event = event
        self.loading = false
        coordinator.pop()
    }

    private func eventAddOrUpdateFailed(error: Error) {
        self.error = error
        self.loading = false
    }

}
