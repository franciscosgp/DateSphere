//
//  AppError.swift
//  DateSphere
//

import Foundation

// MARK: - AppError protocol

protocol AppError: Error, CustomStringConvertible, LocalizedError {}

// MARK: - [Extension] LocalizedError

extension AppError {

    // MARK: Variables

    var errorDescription: String? {
        return description
    }

}
