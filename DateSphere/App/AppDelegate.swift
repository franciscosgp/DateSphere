//
//  AppDelegate.swift
//  DateSphere
//

import Foundation
import UIKit
import UserNotifications

// MARK: - AppDelegate class

final class AppDelegate: NSObject, UIApplicationDelegate, @preconcurrency UNUserNotificationCenterDelegate {

    static private(set) var shared: AppDelegate!

    override init() {
        super.init()
        AppDelegate.shared = self
    }

    // MARK: Dependencies

    var installationRepository: InstallationRepository?

    // MARK: Variables

    var firstNotification: Bool = true
    var launchNotification: [AnyHashable: Any]?
    private var lastAction: Date?
    private var eventAction: EventDomainModel?

    // MARK: Methods

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let repository = installationRepository {
            Task(priority: .background) {
                try? await RegisterInstallationUseCase(installationRepository: repository).execute(deviceToken)
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        NotificationCenter.default.post(name: .notificationReceived, object: notification.request.content.userInfo)
        if let eventObjectId = notification.request.content.userInfo[Constants.NotificationFields.eventId] as? String,
           isLastActionPerfomedByUser(for: eventObjectId) {
            return []
        } else {
            return [.sound, .list, .banner]
        }
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

    func isLastActionPerfomedByUser(for eventObjectId: String) -> Bool {
        if let lastAction, lastAction.timeIntervalSinceNow < 5, eventAction?.objectId == eventObjectId {
            return true
        } else {
            return false
        }
    }

    func updateLastAction(event: EventDomainModel?) {
        lastAction = .now
        eventAction = event
    }

}
