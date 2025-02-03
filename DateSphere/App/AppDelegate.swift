//
//  AppDelegate.swift
//  DateSphere
//

import Foundation
import UIKit
import UserNotifications

// MARK: - AppDelegate class

final class AppDelegate: NSObject, UIApplicationDelegate, @preconcurrency UNUserNotificationCenterDelegate {

    // MARK: Variables

    var firstNotification: Bool = true
    var launchNotification: [AnyHashable: Any]?

    // MARK: Methods

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Task(priority: .background) {
            let dataSource = InstallationDataSource()
            try? await RegisterInstallationUseCase(installationRepository: dataSource).execute(deviceToken)
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .list, .banner]
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificationCenter.default.post(name: .openFromNotification, object: userInfo)
        completionHandler(.newData)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if firstNotification {
            firstNotification = false
            launchNotification = userInfo
        } else {
            NotificationCenter.default.post(name: .openFromNotification, object: userInfo)
        }
        completionHandler()
    }

}
