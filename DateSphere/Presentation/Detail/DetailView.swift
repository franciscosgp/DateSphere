//
//  DetailView.swift
//  DateSphere
//

import DSComponents
import SwiftUI

// MARK: Detail view

struct DetailView: View {

    // MARK: Variables

    @ObservedObject var viewModel: DetailViewModel

    // MARK: Initializers

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Body

    var body: some View {
        if let event = viewModel.event {
            DSCenteredScrollView {

                DSIconView(systemSymbolName: event.iconName,
                           mainColor: event.mainColor ?? .accentColor,
                           secondaryColor: event.secondaryColor ?? .clear,
                           backgroundColor: event.backgroundColor ?? .clear,
                           size: 200,
                           bounceOnTap: true)
                    .padding()

                Text(event.message)
                    .font(.title)
                    .padding(.top)

                Text(event.date.dateFormatted)
                    .font(.title2)
                    .padding(.top)

                ZStack {

                    HStack(alignment: .center) {

                        Button {
                            viewModel.updateCounter(withIncrement: -1)
                        } label: {
                            Image(systemName: "minus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(viewModel.disableMinusAction ? .gray : .red)
                        }
                        .padding(.top, 12)
                        .padding(.horizontal)
                        .disabled(viewModel.disableMinusAction)

                        Text(event.milestonesMessage)
                            .font(.headline)
                            .foregroundStyle(Color.white)
                            .padding(.all, 6)
                            .background {
                                Color.red
                                    .cornerRadius(8)
                            }
                            .padding(.top)

                        Button {
                            viewModel.updateCounter(withIncrement: 1)
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(viewModel.disablePlusAction ? .gray : .red)
                        }
                        .padding(.top, 12)
                        .padding(.horizontal)
                        .disabled(viewModel.disablePlusAction)

                    }

                    if viewModel.isUpdating {
                        DSLoadingView(size: .small)
                            .padding(.top, 12)
                    }
                }

                if let description = event.description {
                    Text(description)
                        .font(.title3)
                        .padding()
                }

            }
            .navigationTitle(event.name)
        } else if let error = viewModel.error {
            DSFeedbackView(title: "alert_error_title".localized,
                           message: error.message,
                           button: .init(title: "retry".localized,
                                         action: { viewModel.loadEvent() }))
        } else {
            DSLoadingView(size: .large)
                .onAppear {
                    viewModel.loadEvent()
                }
        }
    }

}

#if DEBUG
#Preview {
    let dataSource = EventDataSourceMock()
    NavigationStack {
        DetailView(
            viewModel: DetailViewModel(
                objectId: "1",
                useCases: .init(
                    getEventUseCase: .init(eventRepository: dataSource),
                    addOrUpdateEventUseCase: .init(eventRepository: dataSource)
                ),
                saveAction: { _ in }
            )
        )
    }
}
#endif
