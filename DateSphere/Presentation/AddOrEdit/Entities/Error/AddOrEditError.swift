//
//  AddOrEditError.swift
//  DateSphere
//

// MARK: - AddOrEditError enum

enum AddOrEditError: AppError {

    // MARK: Cases

    case empty(field: String)

    // MARK: Variables

    var errorDescription: String? {
        switch self {
        case .empty(let field):
            return String(format: "empty_field_error".localized, field)
        }
    }

}
