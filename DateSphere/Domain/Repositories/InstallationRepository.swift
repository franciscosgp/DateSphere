//
//  InstallationRepository.swift
//  DateSphere
//

import Foundation

// MARK: - InstallationRepository protocol

protocol InstallationRepository {

    // MARK: Methods

    func registerInstallation(with token: Data?) async throws

}
