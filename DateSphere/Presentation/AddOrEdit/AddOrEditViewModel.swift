//
//  AddOrEditViewModel.swift
//  DateSphere
//

import Foundation
import SwiftUI

// MARK: - AddOrEditViewModel class

@MainActor
final class AddOrEditViewModel: ObservableObject {

    // MARK: Dependencies

    private let addOrUpdateEventUseCase: AddOrUpdateEventUseCase

    // MARK: Variables

    // Form fields
    @Published var name: String
    @Published var description: String
    @Published var iconName: String?
    @Published var mainColor: Color
    @Published var secondaryColor: Color
    @Published var backgroundColor: Color
    @Published var date: Date

    // State
    var event: EventDomainModel?
    @Published var isLoading: Bool = false
    @Published var isSaved: Bool = false
    @Published var isFailed: Bool = false
    @Published var error: Error?
    let saveAction: ((EventDomainModel) -> Void)?

    // MARK: Initializers

    init(event: EventDomainModel?, useCase: AddOrUpdateEventUseCase, saveAction: ((EventDomainModel) -> Void)?) {
        self.addOrUpdateEventUseCase = useCase
        self.event = event
        self.saveAction = saveAction

        // Form fields
        name = event?.name ?? ""
        description = event?.description ?? ""
        iconName = event?.iconName
        mainColor = event?.mainColor ?? .accentColor
        secondaryColor = event?.secondaryColor ?? .clear
        backgroundColor = event?.backgroundColor ?? .clear
        date = event?.date ?? Date()

    }

    // MARK: Methods

    func addOrUpdateEvent() {

        // Ensure that the name is not empty
        guard !name.isEmpty else {
            return eventAddOrUpdateFailed(error: AddOrEditError.empty(field: "name".localized.lowercased()))
        }

        // Ensure that the action is not being executed
        guard isLoading == false else { return }
        isLoading = true

        // Create the event and the use case
        let addOrUpdateEventUseCase = addOrUpdateEventUseCase
        let event = EventDomainModel(
            objectId: event?.objectId,
            name: name,
            description: description.isEmpty ? nil : description,
            iconName: iconName,
            mainColor: mainColor,
            secondaryColor: secondaryColor,
            backgroundColor: backgroundColor.isClear ? nil : backgroundColor,
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

    func clearState() {
        isSaved = false
        isFailed = false
        isLoading = false
        error = nil
    }

    // MARK: Private methods

    private func eventAddedOrUpdated(event: EventDomainModel?) {
        self.event = event
        isLoading = false
        if let event {
            saveAction?(event)
        }
        isSaved = true
    }

    private func eventAddOrUpdateFailed(error: Error) {
        self.error = error
        isLoading = false
        isFailed = true
    }

}
