//
//  DateSphereApp.swift
//  DateSphere
//

import SwiftUI

// MARK: - Main app struct

@main
struct DateSphereApp: App {

    // MARK: Variables

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel = RootViewModel(eventRepository: EventDataSource())
    let parseManager: ParseManagerProtocol = ParseManager()
    let installationRepository: InstallationRepository = InstallationDataSource()

    // MARK: Body

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: viewModel)
                .onAppear {
                    parseManager.initialize()
                    appDelegate.installationRepository = installationRepository
                }
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active,
                       let launchNotification = appDelegate.launchNotification {
                        appDelegate.launchNotification = nil
                        showEventFromNotification(launchNotification)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .openFromNotification)) { notification in
                    showEventFromNotification(notification.object as? [AnyHashable : Any])
                }
        }
    }

    // MARK: Methods

    func showEventFromNotification(_ notification: [AnyHashable: Any]?) {
        if let eventId = notification?[Constants.NotificationFields.eventId] as? String {
            viewModel.showEvent(objectId: eventId)
        }
    }

}
