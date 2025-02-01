//
//  AddOrEditView.swift
//  DateSphere
//

import DSComponents
import SwiftUI

// MARK: AddOrEdit view

struct AddOrEditView: View {

    // MARK: Variables

    @ObservedObject var viewModel: AddOrEditViewModel
    @State private var showIconPicker = false

    // MARK: Initializers

    init(viewModel: AddOrEditViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Body

    var body: some View {
        if viewModel.loading {
            getLoadingView()
        } else if let error = viewModel.error {
            getErrorView(error: error)
        } else {

            Form {

                Section(header: Text("Información")) {

                    TextField("Nombre del evento", text: $viewModel.name)
                        .padding(.horizontal, 4)

                    ZStack(alignment: .topLeading) {
                        if viewModel.description.isEmpty {
                            Text("Descripción del evento")
                                .foregroundColor(Color(UIColor.placeholderText))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                        }
                        TextEditor(text: $viewModel.description)
                            .frame(minHeight: 100)
                    }

                }

                Section(header: Text("Icono")) {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(viewModel.iconName == nil ? Color.gray.opacity(0.2) : viewModel.backgroundColor)
                            .frame(width: 120, height: 120)
                            .overlay {
                                if let iconName = viewModel.iconName {
                                    Image(systemName: iconName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60, alignment: .center)
                                        .foregroundStyle(viewModel.foregroundColor)
                                } else {
                                    Text("Sin icono")
                                }
                            }
                            .onTapGesture {
                                showIconPicker.toggle()
                            }
                        Spacer()
                    }
                    Button("Seleccionar icono") {
                        showIconPicker.toggle()
                    }
                    ColorPicker("Color principal", selection: $viewModel.foregroundColor, supportsOpacity: false)
                    ColorPicker("Color de fondo", selection: $viewModel.backgroundColor, supportsOpacity: true)

                }

                    // Sección de fecha
                Section(header: Text("Fecha")) {
                    DatePicker("Fecha del evento", selection: $viewModel.date, displayedComponents: .date)
                }

            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle(viewModel.event == nil ? "Nuevo evento" : "Editar evento")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        viewModel.addOrUpdateEvent()
                    }
                }
            }
            .sheet(isPresented: $showIconPicker) {
                IconPickerView(selectedIcon: $viewModel.iconName)
                    .presentationDetents([.fraction(0.7)])
            }
        }
    }

    // MARK: Methods

    @ViewBuilder
    func getLoadingView() -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2)
    }

    @ViewBuilder
    func getErrorView(error: Error) -> some View {
        DSFeedbackView(message: error.message,
                       button: .init(title: "Volver",
                                     action: viewModel.cleanError))
    }

}

#if DEBUG
#Preview {
    NavigationStack {
        AddOrEditView(
            viewModel: AddOrEditViewModel(
                coordinator: MainCoordinator(),
                event: nil,
                useCase: AddOrUpdateEventUseCase(
                    eventRepository: EventDataSourceMock()
                )
            )
        )
    }
}
#endif
