//
//  DateSphereApp.swift
//  DateSphere
//

import SwiftUI

@main
struct DateSphereApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewModel = RootViewModel(eventRepository: EventDataSource())

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: viewModel)
                .onAppear {
                    ParseManager().initialize()
                }
                .onReceive(NotificationCenter.default.publisher(for: .openFromNotification)) { notification in
                    if let eventId = (notification.object as? [String: Any])?["eventId"] as? String {
                        viewModel.showEvent(objectId: eventId)
                    }
                }
        }
    }

}
