//
//  NetworkError.swift
//  DateSphere
//

// MARK: - NetworkError enum

enum NetworkError: AppError {

    // MARK: Cases

    case noConnection

    // MARK: Variables

    var description: String {
        switch self {
        case .noConnection:
            return "no_connection_error".localized
        }
    }

}
