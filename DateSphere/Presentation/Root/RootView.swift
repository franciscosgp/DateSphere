//
//  RootView.swift
//  DateSphere
//

import SwiftUI

// MARK: RootView

struct RootView: View {

    // MARK: Variables

    @ObservedObject var viewModel: RootViewModel

    // MARK: Initializers

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Body

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ZStack {
                if viewModel.loading {
                    getLoadingView()
                }
                if let error = viewModel.error {
                    getErrorView(error: error)
                } else if viewModel.events.isEmpty {
                    if viewModel.loading {
                        EmptyView()
                    } else {
                        getErrorView(error: RootError.noEvents)
                    }
                } else {
                    List {
                        ForEach(viewModel.events) { event in
                            Button {
                                viewModel.onDetailButtonTapped(event: event)
                            } label: {
                                getView(event: event)
                            }
                            .buttonStyle(.plain)
                            .swipeActions(edge: .trailing) {
                                Button {
                                    viewModel.onDeleteButtonTapped(event: event)
                                } label: {
                                    Text("Eliminar")
                                }
                                .tint(.red)
                                Button {
                                    viewModel.onEditButtonTapped(event: event)
                                } label: {
                                    Text("Editar")
                                }
                                .tint(.yellow)
                            }
                        }
                    }
                    .refreshable {
                        viewModel.loadEvents()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.onAddButtonTapped()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .navigationDestination(for: MainCoordinator.Destination.self) { destination in
                switch destination {
                case .addOrEditEvent:
                    if let viewModel = viewModel.coordinator.addOrEditEventViewModel {
                        AddOrEditView(viewModel: viewModel)
                    }
                case .detail:
                    if let viewModel = viewModel.coordinator.detailViewModel {
                        DetailView(viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("DateSphere")
            .onAppear {
                viewModel.loadEvents()
            }
        }
    }

    // MARK: Methods

    func getView(event: EventDomainModel) -> some View {
        HStack {
            Circle()
                .fill(event.backgroundColor ?? .clear)
                .frame(width: 50, height: 50)
                .overlay {
                    event.icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: event.backgroundColor == nil ? 40 : 25, height: event.backgroundColor == nil ? 40 : 25, alignment: .center)
                        .foregroundStyle(event.foregroundColor ?? .accentColor)
                }
            VStack {
                Text(event.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .bold()
                Text(event.message)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
            }
        }
    }

    @ViewBuilder
    func getLoadingView() -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2)
    }

    @ViewBuilder
    func getErrorView(error: Error) -> some View {

        Image(systemName: "exclamationmark.triangle")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .padding()

        Text("Se ha producido un error")
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .padding(.horizontal)

        Text(error.localizedDescription)
            .font(.title3)
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.top, 2)

        Button("Reintentar") {
            viewModel.loadEvents()
        }
        .buttonStyle(.borderedProminent)
        .padding()

    }

    @MainActor
    func requestNotificationPermissions() {
        Task {
            do {
                let center = UNUserNotificationCenter.current()
                let granted = try await center.requestAuthorization()
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } catch {
                print("Error al pedir permisos: \(error.localizedDescription)")
            }
        }
    }

}

#if DEBUG
#Preview {
    let mockDataSource = EventDataSourceMock()
    RootView(
        viewModel: RootViewModel(
            coordinator: MainCoordinator(),
            getEventsUseCase: GetEventsUseCase(eventRepository: mockDataSource),
            deleteEventUseCase: DeleteEventUseCase(eventRepository: mockDataSource)
        )
    )
}
#endif
