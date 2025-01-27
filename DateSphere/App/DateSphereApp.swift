//
//  DateSphereApp.swift
//  DateSphere
//

import SwiftUI

@main
struct DateSphereApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var coordinator = MainCoordinator()

    var body: some Scene {
        WindowGroup {
            coordinator.start()
                .onAppear {
                    coordinator.setup()
                }
        }
    }

}
