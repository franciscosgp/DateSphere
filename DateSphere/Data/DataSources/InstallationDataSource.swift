//
//  InstallationDataSource.swift
//  DateSphere
//

import Foundation
@preconcurrency import ParseSwift

// MARK: - InstallationDataSource actor

final actor InstallationDataSource: InstallationRepository {

    // MARK: Methods

    func registerInstallation(with token: Data?) async throws {
        var installation = InstallationDataModel.current
        installation?.channels = Constants.Global.notificationChannels
        if let token {
            installation?.setDeviceToken(token)
        }
        try await installation?.save()
    }

}
