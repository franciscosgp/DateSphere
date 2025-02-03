//
//  InstallationDataSourceMock.swift
//  DateSphere
//

import Foundation

#if DEBUG

// MARK: - InstallationDataSourceMock actor

final actor InstallationDataSourceMock: InstallationRepository {

    // MARK: Methods

    func registerInstallation(with token: Data?) async throws {}

}

#endif
