//
//  DateSphereApp.swift
//  DateSphere
//

import SwiftUI

@main
struct DateSphereApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    ParseManager().initialize()
                }
        }
    }

}
