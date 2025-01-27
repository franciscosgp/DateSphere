//
//  MapperError.swift
//  DateSphere
//

// MARK: - MapperError enum

enum MapperError: Error {

    // MARK: Cases

    case notAllowed(parameter: String)
    case required(parameter: String)

}

// MARK: - [Extension] CustomStringConvertible

extension MapperError: CustomStringConvertible {

    // MARK: Variables

    var description: String {
        switch self {
        case .notAllowed(let parameter):
            return "\(parameter) is not allowed"
        case .required(let parameter):
            return "\(parameter) is required"
        }
    }

}
