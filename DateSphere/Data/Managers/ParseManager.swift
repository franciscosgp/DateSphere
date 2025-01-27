//
//  ParseManager.swift
//  DateSphere
//

import ParseSwift

// MARK: - ParseManager protocol

protocol ParseManagerProtocol {

    // MARK: Methods

    func initialize()

}

// MARK: - ParseManager class

class ParseManager: ParseManagerProtocol {

    // MARK: Methods

    func initialize() {
        ParseSwift.initialize(
            applicationId: Constants.Parse.applicationId,
            clientKey: Constants.Parse.clientKey,
            serverURL: Constants.Parse.serverURL
        )
    }

}
