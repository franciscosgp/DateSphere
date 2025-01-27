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

    // MARK: Parse struct

    struct Parse {

        // MARK: Static variables

        static let applicationId = String(key: [0])! // Set your Application ID
        static let clientKey = String(key: [0])! // Set your Client Key
        static let serverURL = URL(string: String(key: [0])!)! // Set your Server URL

    }

    // MARK: Security struct

    struct Security {

        // MARK: Static variables

        static let salt = "\(String(describing: NSString.self))\(String(describing: NSObject.self))\(String(describing: CGFloat.self))"

    }

}
