//
//  NewEvent.swift
//  DateSphere
//

import SwiftUI

struct EventFormView: View {

    @Environment(\.dismiss) private var dismiss

    let eventDataSource = EventDataSource()

    private var event: EventDomainModel? = nil
    @State private var nombre: String = ""
    @State private var descripcion: String = ""
    @State private var icon: String? = nil
    @State private var foregroundColor: Color = .accentColor
    @State private var backgroundColor: Color = .gray.opacity(0.2)
    @State private var fecha: Date = Date()
    @State private var mostrarImagePicker = false

    init(event: EventDomainModel? = nil) {
        self.event = event
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información")) {
                    TextField("Nombre del evento", text: $nombre)
                        .padding(.horizontal, 4)
                    ZStack(alignment: .topLeading) {
                        if descripcion.isEmpty {
                            Text("Descripción del evento")
                                .foregroundColor(Color(UIColor.placeholderText))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                        }
                        TextEditor(text: $descripcion)
                            .frame(minHeight: 100)
                    }
                }

                Section(header: Text("Icono")) {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(icon != nil ? backgroundColor : Color.gray.opacity(0.2))
                            .frame(width: 120, height: 120)
                            .overlay {
                                if let icon = icon {
                                    Image(systemName: icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60, alignment: .center)
                                        .foregroundStyle(foregroundColor)
                                } else {
                                    Text("Sin icono")
                                }
                            }
                            .onTapGesture {
                                mostrarImagePicker.toggle()
                            }
                        Spacer()
                    }
                    Button("Seleccionar icono") {
                        mostrarImagePicker.toggle()
                    }
                    ColorPicker("Color principal", selection: $foregroundColor, supportsOpacity: false)
                    ColorPicker("Color de fondo", selection: $backgroundColor, supportsOpacity: true)

                }

                // Sección de fecha
                Section(header: Text("Fecha")) {
                    DatePicker("Fecha del evento", selection: $fecha, displayedComponents: .date)
                }

            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle(event == nil ? "Nuevo evento" : "Editar evento")
            .toolbar {

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        Task {
                            let newEvent = EventDomainModel(objectId: event?.objectId, name: nombre, description: descripcion, iconName: icon, foregroundColor: foregroundColor, backgroundColor: backgroundColor, date: fecha)
                            do {
                                let event = try await AddOrUpdateEventUseCase(eventRepository: eventDataSource).execute(newEvent)
                                print("Evento guardado: \(event?.name ?? "(null)")")
                            } catch {
                                print("Error al guardar el evento: \(error)")
                            }
                        }
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $mostrarImagePicker) {
                IconPickerView(selectedIcon: $icon)
                    .presentationDetents([.fraction(0.7)])
            }.onAppear {
                if let event = event {
                    nombre = event.name
                    descripcion = event.description ?? ""
                    icon = event.iconName
                    foregroundColor = event.foregroundColor ?? .accentColor
                    backgroundColor = event.backgroundColor ?? .gray.opacity(0.2)
                    fecha = event.date
                }
            }
        }
    }
}

#Preview {
    EventFormView()
}
