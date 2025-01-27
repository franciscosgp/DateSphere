//
//  BaseUseCase.swift
//  DateSphere
//

import Foundation

// MARK: - Base use case

class BaseUseCase<Input, Output> {

    // MARK: Initializers

    internal init() {}

    // MARK: Methods

    /**
     Main method of executing the useCase.
     This method executes the `handle(input: Input? = nil) async throws -> Output?` which use async/await.

     - Parameters:
     - input: The only parameter where it will have all the necessary properties to execute the useCase.
     - Returns: It returns an object of type `Output`.
     */
    func execute(_ input: Input? = nil) async throws -> Output? {
        guard let handle = try await handle(input: input) else {
            return nil
        }
        return handle
    }

    /**
     This function must be overridden to add code that we want to execute the use case with async/await.

     - Parameters:
     - input: The only parameter where it will have all the necessary properties to execute the useCase.
     - Returns: It returns an object of type `Output`.
     */
    open func handle(input: Input? = nil) async throws -> Output? { nil }

}
