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

                if event.counter > 0 {
                    Text(event.milestonesMessage)
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .padding(.all, 6)
                        .background {
                            Color.red
                                .cornerRadius(8)
                        }
                        .padding(.top)
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
    NavigationStack {
        DetailView(
            viewModel: DetailViewModel(
                objectId: "1",
                useCase: .init(eventRepository: EventDataSourceMock())
            )
        )
    }
}
#endif
