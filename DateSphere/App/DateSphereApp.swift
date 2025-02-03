//
//  DateSphereApp.swift
//  DateSphere
//

import SwiftUI

@main
struct DateSphereApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel = RootViewModel(eventRepository: EventDataSource())

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: viewModel)
                .onAppear {
                    ParseManager().initialize()
                }
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        if let launchNotification = appDelegate.launchNotification {
                            appDelegate.launchNotification = nil
                            if let eventId = launchNotification["eventId"] as? String {
                                viewModel.showEvent(objectId: eventId)
                            }
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .openFromNotification)) { notification in
                    if let eventId = (notification.object as? [String: Any])?["eventId"] as? String {
                        viewModel.showEvent(objectId: eventId)
                    }
                }
        }
    }

}
