//
//  DetailView.swift
//  DateSphere
//

import SwiftUI

// MARK: Detail view

struct DetailView: View {

    // MARK: Variables

    @ObservedObject var viewModel: DetailViewModel
    @State private var scale: CGFloat = 1.0

    // MARK: Initializers

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Body

    var body: some View {
        if let event = viewModel.event {
            ScrollView {

                Circle()
                    .fill(event.backgroundColor ?? .clear)
                    .frame(width: 200, height: 200)
                    .overlay {
                        event.icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: event.backgroundColor == nil ? 180 : 100, height: event.backgroundColor == nil ? 180 : 100, alignment: .center)
                            .foregroundStyle(event.foregroundColor ?? .accentColor)
                            .scaleEffect(scale)
                    }
                    .onTapGesture {
                        withAnimation(.interpolatingSpring(stiffness: 150, damping: 5)) {
                            self.scale = 1.2
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.interpolatingSpring(stiffness: 150, damping: 5)) {
                                self.scale = 1.0
                            }
                        }
                    }
                    .padding()

                Text(event.message)
                    .font(.title)
                    .padding()

                Text(event.date.dateFormatted)
                    .font(.title2)
                    .padding()

                if let description = event.description {
                    Text(description)
                        .font(.title3)
                        .padding()
                }

            }
            .navigationTitle(event.name)
        } else if let error = viewModel.error {
            getErrorView(error: error)
        } else {
            getLoadingView()
        }
    }

    // MARK: Methods

    @ViewBuilder
    func getLoadingView() -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2)
            .onAppear {
                viewModel.loadEvent()
            }
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
            viewModel.loadEvent()
        }
        .buttonStyle(.borderedProminent)
        .padding()

    }

}

#if DEBUG
#Preview {
    NavigationStack {
        DetailView(
            viewModel: DetailViewModel(
                coordinator: MainCoordinator(),
                objectId: "1",
                useCase: GetEventUseCase(
                    eventRepository: EventDataSourceMock()
                )
            )
        )
    }
}
#endif
