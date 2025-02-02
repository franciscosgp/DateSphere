//
//  ListError.swift
//  DateSphere
//

// MARK: - ListError enum

enum ListError: AppError {

    // MARK: Cases

    case noEvents

    // MARK: Variables

    var errorDescription: String? {
        switch self {
        case .noEvents:
            return "no_events".localized
        }
    }

}
