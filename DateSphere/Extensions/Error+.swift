//
//  Error+.swift
//  DateSphere
//

import Foundation
@preconcurrency import ParseSwift

// MARK: - [Extension] Error

extension Error {

    // MARK: Variables

    var message: String? {
        if let error = self as? ParseError {
            return "\(error.message)"
        } else if let error = self as? AppError {
            return error.description
        } else {
            return localizedDescription
        }
    }

}
