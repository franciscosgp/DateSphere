//
//  AddOrEditView.swift
//  DateSphere
//

import DSComponents
import SwiftUI

// MARK: AddOrEdit view

struct AddOrEditView: View {

    // MARK: Variables

    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: AddOrEditViewModel
    @State private var showIconPicker = false

    // MARK: Initializers

    init(viewModel: AddOrEditViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            Form {

                Section(header: Text("information")) {

                    TextField("event_name", text: $viewModel.name)
                        .padding(.horizontal, 4)

                    ZStack(alignment: .topLeading) {
                        if viewModel.description.isEmpty {
                            Text("event_description")
                                .foregroundColor(Color(UIColor.placeholderText))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                        }
                        TextEditor(text: $viewModel.description)
                            .frame(minHeight: 100)
                    }

                }

                Section(header: Text("icon")) {
                    HStack {
                        Spacer()
                        Button(action: {
                            showIconPicker.toggle()
                        }) {
                            DSIconView(systemSymbolName: $viewModel.iconName,
                                       mainColor: $viewModel.mainColor,
                                       secondaryColor: $viewModel.secondaryColor,
                                       backgroundColor: $viewModel.backgroundColor,
                                       noIconText: "select_icon".localized)
                        }
                        Spacer()
                    }
                    ColorPicker("main_color", selection: $viewModel.mainColor, supportsOpacity: false)
                    ColorPicker("secondary_color", selection: $viewModel.secondaryColor, supportsOpacity: true)
                    ColorPicker("background_color", selection: $viewModel.backgroundColor, supportsOpacity: true)

                }

                Section(header: Text("date")) {
                    DatePicker("event_date", selection: $viewModel.date, displayedComponents: .date)
                }

            }
            .disabled(viewModel.isLoading)
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle(viewModel.event == nil ? "new_event" : "edit_event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("close") {
                        dismiss()
                    }.disabled(viewModel.isLoading)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if viewModel.isLoading {
                        DSLoadingView(size: .small)
                    } else {
                        Button("save") {
                            viewModel.addOrUpdateEvent()
                        }
                    }
                }
            }
            .sheet(isPresented: $showIconPicker) {
                DSIconPickerView(selectedIcon: $viewModel.iconName)
                    .presentationDetents([.fraction(0.7)])
            }
            .alert("alert_error_title", isPresented: $viewModel.isFailed) {
                Button("close", role: .cancel, action: viewModel.clearState)
            } message: {
                if let error = viewModel.error {
                    Text(error.message)
                        .lineLimit(4)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                }
            }
            .onChange(of: viewModel.isSaved) { isSaved in
                if isSaved {
                    dismiss()
                }
            }
        }

    }

}

#if DEBUG
#Preview {
    NavigationStack {
        AddOrEditView(
            viewModel: AddOrEditViewModel(
                event: nil,
                useCase: .init(eventRepository: EventDataSourceMock()),
                saveAction: { _ in }
            )
        )
    }
}
#endif
