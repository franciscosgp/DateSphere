//
//  MapperError.swift
//  DateSphere
//

// MARK: - MapperError enum

enum MapperError: AppError {

    // MARK: Cases

    case notAllowed(parameter: String)
    case required(parameter: String)

    // MARK: Variables

    var description: String {
        switch self {
        case .notAllowed(let parameter):
            return String(format: "parameter_not_allowed".localized, parameter).capitalized
        case .required(let parameter):
            return String(format: "parameter_required".localized, parameter).capitalized
        }
    }

}
