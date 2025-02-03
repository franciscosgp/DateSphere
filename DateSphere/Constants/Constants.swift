//
//  Constants.swift
//  DateSphere
//

import Foundation

// MARK: - Constants struct

struct Constants {

    // MARK: Global struct

    struct Global {

        // MARK: Static variables

        static let dateFormat = "dd/MM/yyyy"
        static let notificationChannels = ["events"]

    }

    // MARK: Security struct

    struct Security {

        // MARK: Static variables

        static let salt = "\(String(describing: NSString.self))\(String(describing: NSObject.self))\(String(describing: CGFloat.self))"

    }

    // MARK: Notification fields struct

    struct NotificationFields {

        // MARK: Static variables

        static let eventId = "eventId"

    }

}
