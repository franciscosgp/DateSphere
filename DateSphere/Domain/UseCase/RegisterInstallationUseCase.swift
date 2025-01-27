//
//  RegisterInstallationUseCase.swift
//  DateSphere
//

import Foundation

// MARK: - RegisterInstallationUseCase class

final class RegisterInstallationUseCase: BaseUseCase<Data, Void> {

    // MARK: Variables

    private let installationRepository: InstallationRepository

    // MARK: Initializers

    init(installationRepository: InstallationRepository) {
        self.installationRepository = installationRepository
        super.init()
    }

    // MARK: Methods

    override func handle(input: Data? = nil) async throws {
        try await installationRepository.registerInstallation(with: input)
    }

}
