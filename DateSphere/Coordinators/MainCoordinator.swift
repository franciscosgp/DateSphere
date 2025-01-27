//
//  MainCoordinator.swift
//  DateSphere
//

import SwiftUI

// MARK: - MainCoordinator class

@MainActor
final class MainCoordinator: Coordinator {

    // MARK: Destination enum

    enum Destination {

        // MARK: Cases

        case addOrEditEvent
        case detail

    }

    // MARK: Variables

    let dataSource: EventDataSource = EventDataSource()

    @Published var path = NavigationPath()
    lazy var rootViewModel: RootViewModel = {
        RootViewModel(coordinator: self, getEventsUseCase: GetEventsUseCase(eventRepository: dataSource), deleteEventUseCase: DeleteEventUseCase(eventRepository: dataSource))
    }()
    var addOrEditEventViewModel: AddOrEditViewModel?
    var detailViewModel: DetailViewModel?

    // MARK: Methods

    func start() -> some View {
        RootView(viewModel: rootViewModel)
    }

    func goToAddOrEditEvent(event: EventDomainModel? = nil) {
        addOrEditEventViewModel = AddOrEditViewModel(coordinator: self, event: event, useCase: AddOrUpdateEventUseCase(eventRepository: dataSource))
        path.append(Destination.addOrEditEvent)
    }

    func goToDetail(objectId: String) {
        detailViewModel = DetailViewModel(coordinator: self, objectId: objectId, useCase: GetEventUseCase(eventRepository: dataSource))
        path.append(Destination.detail)
    }

    func goToDetail(event: EventDomainModel) {
        detailViewModel = DetailViewModel(coordinator: self, event: event)
        path.append(Destination.detail)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func setup() {
        ParseManager().initialize()
    }

}
