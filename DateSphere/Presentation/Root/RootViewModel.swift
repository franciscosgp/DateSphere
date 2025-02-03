//
//  RootViewModel.swift
//  DateSphere
//

import UserNotifications
import SwiftUI

// MARK: - RootViewModel class

@MainActor
final class RootViewModel: ObservableObject {

    // MARK: Destination types

    enum Destination: Hashable {
        case detail(objectId: String?, event: EventDomainModel?)
    }

    // MARK: Variables

    let eventRepository: EventRepository
    @Published var path = NavigationPath()
    @Published var showAddOrEdit = false
    var currentEvent: EventDomainModel?
    var saveAction: ((EventDomainModel) -> Void)?

    // MARK: Dependencies

    private lazy var addOrUpdateEventUseCase: AddOrUpdateEventUseCase = { .init(eventRepository: eventRepository) }()
    private lazy var getEventsUseCase: GetEventsUseCase = { .init(eventRepository: eventRepository) }()
    private lazy var getEventUseCase: GetEventUseCase = { .init(eventRepository: eventRepository) }()
    private lazy var deleteEventUseCase: DeleteEventUseCase = { .init(eventRepository: eventRepository) }()

    // MARK: Initializers

    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository
    }

    // MARK: View models

    lazy var listViewModel: ListViewModel = {
        .init(
            useCases: .init(
                getEventsUseCase: getEventsUseCase,
                deleteEventUseCase: deleteEventUseCase
            ),
            actions: .init(
                addEvent: { [weak self] completion in
                    self?.addEvent()
                    self?.saveAction = completion
                },
                viewEvent: { [weak self] event in
                    self?.showEvent(event: event)
                },
                editEvent: { [weak self] event, completion in
                    self?.editEvent(event: event)
                    self?.saveAction = completion
                }
            )
        )
    }()

    func getAddOrEditViewModel() -> AddOrEditViewModel {
        .init(event: currentEvent,
              useCase: addOrUpdateEventUseCase,
              saveAction: saveAction)
    }

    func getDetailViewModel(objectId: String? = nil, event: EventDomainModel?) -> DetailViewModel? {
        if let event {
            return .init(event: event)
        } else if let objectId {
            return .init(objectId: objectId, useCase: getEventUseCase)
        } else {
            return nil
        }
    }

    // MARK: Actions methods

    func addEvent() {
        currentEvent = nil
        showAddOrEdit.toggle()
    }

    func editEvent(event: EventDomainModel) {
        currentEvent = event
        showAddOrEdit.toggle()
    }

    func showEvent(objectId: String) {
        path.append(Destination.detail(objectId: objectId, event: nil))
    }

    func showEvent(event: EventDomainModel) {
        path.append(Destination.detail(objectId: nil, event: event))
    }

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
                    if granted {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            case .denied, .ephemeral:
                break
            @unknown default:
                break
            }
        }
    }

}
