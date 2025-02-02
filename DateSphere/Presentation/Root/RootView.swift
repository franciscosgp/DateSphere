//
//  RootView.swift
//  DateSphere
//

import DSComponents
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
            ListView(viewModel: viewModel.listViewModel)
                .navigationDestination(for: RootViewModel.Destination.self) { destination in
                    switch destination {
                    case .detail(let objectId, let event):
                        if let viewModel = viewModel.getDetailViewModel(objectId: objectId, event: event) {
                            DetailView(viewModel: viewModel)
                        }
                    }
                }
                .sheet(isPresented: $viewModel.showAddOrEdit) {
                    AddOrEditView(viewModel: viewModel.getAddOrEditViewModel())
                }
                .navigationTitle("DateSphere")
                .onAppear {
                    viewModel.requestNotificationPermission()
                }
        }
    }

}
