//
//  ListView.swift
//  DateSphere
//

import DSComponents
import SwiftUI

// MARK: ListView

struct ListView: View {

    // MARK: Variables

    @ObservedObject var viewModel: ListViewModel

    // MARK: Initializers

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Body

    var body: some View {
        ZStack {
            if let error = viewModel.error {
                DSFeedbackView(title: "alert_error_title".localized,
                               message: error.message,
                               button: .init(title: "retry".localized,
                                             action: { Task { await viewModel.loadEvents() } }))
            } else if viewModel.events.isEmpty {
                if viewModel.loading {
                    EmptyView()
                } else {
                    DSFeedbackView(style: .warning,
                                   title: "no_events".localized,
                                   message: "no_events_description".localized,
                                   button: .init(title: "retry".localized,
                                                 action: { Task { await viewModel.loadEvents() } }))
                }
            } else {
                List {
                    ForEach(viewModel.events) { event in
                        Button {
                            viewModel.onDetailButtonTapped(event: event)
                        } label: {
                            getView(event: event)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.onDeleteButtonTapped(event: event)
                            } label: {
                                Text("delete")
                            }
                            .tint(.red)
                            Button {
                                viewModel.onEditButtonTapped(event: event)
                            } label: {
                                Text("edit")
                            }
                            .tint(.yellow)
                        }
                    }
                }
                .disabled(viewModel.loading)
                .refreshable {
                    await viewModel.loadEvents(showLoading: false)
                }
            }
            if viewModel.showLoading {
                DSLoadingView(size: .large)
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
        .navigationTitle("DateSphere")
        .alert(viewModel.removeAlertMessage, isPresented: $viewModel.showRemoveConfirmation) {
            Button("delete", role: .destructive, action: viewModel.onDeleteConfirmButtonTapped)
            Button("close", role: .cancel, action: viewModel.clearState)
        }
    }

    // MARK: Methods

    func getView(event: EventDomainModel) -> some View {
        HStack {
            DSIconView(systemSymbolName: event.iconName,
                       mainColor: event.mainColor ?? .accentColor,
                       secondaryColor: event.secondaryColor ?? .clear,
                       backgroundColor: event.backgroundColor ?? .clear,
                       size: 50)
            VStack {
                Text(event.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.primary)
                Text(event.message)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            if event.counter > 0 {
                Circle()
                    .fill(.red)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .overlay {
                        Text(String(Int(event.counter)))
                            .font(.subheadline)
                            .foregroundStyle(Color.white)
                            .frame(width: 24, height: 24, alignment: .center)
                    }
            }

        }
    }

}

#if DEBUG
#Preview {
    let mockDataSource = EventDataSourceMock()
    ListView(
        viewModel: ListViewModel(
            useCases: .init(
                getEventsUseCase: .init(eventRepository: mockDataSource),
                deleteEventUseCase: .init(eventRepository: mockDataSource)),
            actions: .init(addEvent: { _ in },
                           viewEvent: { _ in },
                           editEvent: { _, _ in })
        )
    )
}
#endif
