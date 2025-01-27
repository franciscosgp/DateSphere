//
//  AddOrEditError.swift
//  DateSphere
//

// MARK: - AddOrEditError enum

enum AddOrEditError: AppError {

    // MARK: Cases

    case empty(parameter: String)

    // MARK: Variables

    var description: String {
        switch self {
        case .empty(let parameter):
            return "El parámetro \(parameter) no puede estar vacío"
        }
    }

}
