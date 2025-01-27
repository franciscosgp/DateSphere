//
//  AppDelegate.swift
//  DateSphere
//

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Task(priority: .background) {
            do {
                let dataSource = InstallationDataSource()
                try await RegisterInstallationUseCase(installationRepository: dataSource).execute(deviceToken)
            } catch {
                print("Failed to update installation: \(error)")
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }

}
