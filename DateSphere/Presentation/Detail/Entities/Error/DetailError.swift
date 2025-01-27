//
//  DetailError.swift
//  DateSphere
//

// MARK: - DetailError enum

enum DetailError: AppError {

    // MARK: Cases

    case requireUseCase

    // MARK: Variables

    var description: String {
        switch self {
        case .requireUseCase:
            return "It's required to use a GetEventUseCase"
        }
    }

}
