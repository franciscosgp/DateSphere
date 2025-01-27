//
//  InstallationDataModel.swift
//  DateSphere
//

import Foundation
@preconcurrency import ParseSwift

// MARK: - InstallationDataModel struct

struct InstallationDataModel: ParseInstallation, Sendable {

    // MARK: Variables

    // Parse variables
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Installation variables
    var installationId: String?
    var deviceType: String?
    var deviceToken: String?
    var badge: Int?
    var timeZone: String?
    var channels: [String]?
    var appName: String?
    var appIdentifier: String?
    var appVersion: String?
    var parseVersion: String?
    var localeIdentifier: String?

    // MARK: Methods

    func merge(with object: Self) throws -> Self {
        return try mergeParse(with: object)
    }

}
