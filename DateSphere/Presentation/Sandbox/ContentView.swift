//
//  ContentView.swift
//  DateSphere
//

import UserNotifications
import ParseSwift
import SwiftUI
import UIKit

struct ContentView: View {

    let eventDataSource = EventDataSource()

    @State private var events: [EventDomainModel] = []
    @State private var showEventForm = false
    @State private var eventForm: EventDomainModel?

    var body: some View {
        NavigationView {
            List {
                ForEach(events) { event in
                    NavigationLink {
                        DetailView(event: event)
                    } label: {
                        getView(event: event)
                    }.swipeActions(edge: .trailing) {
                        Button {
                            Task {
                                do {
                                    try await DeleteEventUseCase(eventRepository: eventDataSource).execute(event)
                                    events.removeAll(where: { $0.id == event.id })
                                    print("Event deleted successfully")
                                } catch {
                                    print("Error deleting event: \(error)")
                                }
                            }
                        } label: {
                            Text("Eliminar")
                        }
                        .tint(.red)
                        Button {
                            eventForm = event
                            showEventForm = true
                        } label: {
                            Text("Editar")
                        }
                        .tint(.yellow)
                    }
                }
            }
            .navigationTitle("DateSphere")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showEventForm.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .onAppear {
            requestNotificationPermissions()
            Task {
                do {
                    events = try await GetEventsUseCase(eventRepository: eventDataSource).execute() ?? []
                } catch {
                    print("Error fetching events: \(error)")
                }
            }
        }
        .refreshable {
            Task {
                do {
                    events = try await GetEventsUseCase(eventRepository: eventDataSource).execute() ?? []
                } catch {
                    print("Error fetching events: \(error)")
                }
            }
        }
        .sheet(isPresented: $showEventForm) {
            EventFormView(event: eventForm)
        }
        .onChange(of: showEventForm) { newValue in
            if newValue == false {
                eventForm = nil
                Task {
                    do {
                        events = try await GetEventsUseCase(eventRepository: eventDataSource).execute() ?? []
                    } catch {
                        print("Error fetching events: \(error)")
                    }
                }
            }
        }
    }

    func getView(event: EventDomainModel) -> some View {
        HStack {
            Circle()
                .fill(event.backgroundColor ?? .clear)
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: event.iconName ?? "questionmark")
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
                Text(event.date.isToday ? "HOY" :"\(event.date.numberOfDays) días")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
            }
        }
    }

    @MainActor var counter = 0

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

#Preview {
    ContentView()
}
