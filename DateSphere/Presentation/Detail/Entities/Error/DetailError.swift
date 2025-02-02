//
//  DetailError.swift
//  DateSphere
//

// MARK: - DetailError enum

enum DetailError: AppError {

    // MARK: Cases

    case requireUseCase

    // MARK: Variables

    var errorDescription: String? {
        switch self {
        case .requireUseCase:
            return "error_required_GetEventUseCase".localized
        }
    }

}
