//
//  RootError.swift
//  DateSphere
//

// MARK: - RootError enum

enum RootError: AppError {

    // MARK: Cases

    case noEvents

    // MARK: Variables

    var description: String {
        switch self {
        case .noEvents:
            return "No hay eventos"
        }
    }

}
