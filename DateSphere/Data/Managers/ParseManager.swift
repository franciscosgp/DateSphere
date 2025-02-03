//
//  ParseManager.swift
//  DateSphere
//

import ParseSwift

// MARK: - ParseManager protocol

protocol ParseManagerProtocol {

    // MARK: Methods

    func initialize() async

}

// MARK: - ParseManager class

final actor ParseManager: ParseManagerProtocol {

    // MARK: Methods

    func initialize() async {
        ParseSwift.initialize(
            applicationId: Constants.Parse.applicationId,
            clientKey: Constants.Parse.clientKey,
            serverURL: Constants.Parse.serverURL
        )
    }

}

#if DEBUG

// MARK: - ParseManagerMock class

final actor ParseManagerMock: ParseManagerProtocol {

    // MARK: Methods

    func initialize() async {}

}

#endif
