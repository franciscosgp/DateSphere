//
//  DateSphereApp.swift
//  DateSphere
//

import SwiftUI

@main
struct DateSphereApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    /*var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    ParseManager().initialize()
                }
        }
    }*/

    /// Coordinador principal, se encarga del flujo global de la app
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
