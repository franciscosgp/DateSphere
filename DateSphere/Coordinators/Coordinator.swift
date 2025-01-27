//
//  Coordinator.swift
//  DateSphere
//

import SwiftUI

// MARK: - Coordinator protocol

@MainActor
protocol Coordinator: ObservableObject {

    // MARK: Associated types

    associatedtype SomeView: View

    // MARK: Methods

    func start() -> SomeView
    func popToRoot()
    func pop()

}
