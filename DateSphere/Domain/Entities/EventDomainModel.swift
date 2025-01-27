//
//  EventDomainModel.swift
//  DateSphere
//

import Foundation
import SwiftUICore

// MARK: - EventDomainModel struct

struct EventDomainModel: Hashable, Equatable, Sendable {

    // MARK: Variables

    let objectId: String?
    let name: String
    let description: String?
    let iconName: String?
    let foregroundColor: Color?
    let backgroundColor: Color?
    let date: Date

    var message: String {
        if date.isToday {
            return "HOY"
        } else if date.isInFuture {
            return "Quedan \(date.numberOfDays) días"
        } else {
            return "Hace \(date.numberOfDays) días"
        }
    }

    var icon: Image {
        return Image(systemName: iconName ?? "questionmark")
    }

}

// MARK: - [Extension] Identifiable

extension EventDomainModel: Identifiable {

    // MARK: Variables

    var id: String {
        return objectId ?? UUID().uuidString
    }

}

// MARK: - [Extensions] Initializers

extension EventDomainModel {

    // MARK: Initializers

    init(name: String, description: String?, iconName: String?, foregroundColor: Color?, backgroundColor: Color?, date: Date) {
        self.objectId = nil
        self.name = name
        self.description = description
        self.iconName = iconName
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.date = date
    }

}
