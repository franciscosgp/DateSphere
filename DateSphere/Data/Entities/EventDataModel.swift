//
//  EventDataModel.swift
//  DateSphere
//

import Foundation
@preconcurrency import ParseSwift
import SwiftUICore

// MARK: - EventDataModel struct

struct EventDataModel: ParseObject, Sendable {

    // MARK: Static variables

    /// The name of the class in the Parse Server schema.
    static var className: String {
        return "Event"
    }

    // MARK: Variables

    // Parse variables
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Custom variables
    var name: String?
    var description: String?
    var icon: String?
    var foregroundColor: String?
    var backgroundColor: String?
    var date: Date?

    // MARK: Methods

    func merge(with object: Self) throws -> Self {
        var updated = try mergeParse(with: object)
        if updated.shouldRestoreKey(\.name,
                                     original: object) {
            updated.name = object.name
        }
        if updated.shouldRestoreKey(\.description,
                                     original: object) {
            updated.description = object.description
        }
        if updated.shouldRestoreKey(\.icon,
                                     original: object) {
            updated.icon = object.icon
        }
        if updated.shouldRestoreKey(\.foregroundColor,
                                     original: object) {
            updated.foregroundColor = object.foregroundColor
        }
        if updated.shouldRestoreKey(\.backgroundColor,
                                     original: object) {
            updated.backgroundColor = object.backgroundColor
        }
        if updated.shouldRestoreKey(\.date,
                                     original: object) {
            updated.date = object.date
        }
        return updated
    }

}

// MARK: - [Extensions] Initializers

extension EventDataModel {

    // MARK: Initializers

    init(name: String, description: String?, icon: String?, foregroundColor: String?, backgroundColor: String?, date: Date) {
        self.name = name
        self.description = description
        self.icon = icon
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.date = date
    }

    init(with domainModel: EventDomainModel) throws {
        guard domainModel.objectId == nil else { throw MapperError.notAllowed(parameter: "objectId") }
        self.init(name: domainModel.name,
                  description: domainModel.description,
                  icon: domainModel.iconName,
                  foregroundColor: domainModel.foregroundColor?.toHex(),
                  backgroundColor: domainModel.backgroundColor?.toHex(),
                  date: domainModel.date)
    }

    init(objectId: String?) {
        self.objectId = objectId
    }

}

// MARK: - [Extensions] DomainModel mapper

extension EventDataModel {

    // MARK: Methods

    func merge(with domainModel: EventDomainModel) throws -> Self {
        var updated = self
        updated.name = domainModel.name
        updated.description = domainModel.description
        updated.icon = domainModel.iconName
        updated.foregroundColor = domainModel.foregroundColor?.toHex()
        updated.backgroundColor = domainModel.backgroundColor?.toHex()
        updated.date = domainModel.date
        return updated
    }

    func parseToDomainModel() throws -> EventDomainModel {
        guard let name else { throw MapperError.required(parameter: "name") }
        guard let date else { throw MapperError.required(parameter: "date") }
        return EventDomainModel(
            objectId: objectId,
            name: name,
            description: description,
            iconName: icon,
            foregroundColor: Color(hex: foregroundColor),
            backgroundColor: Color(hex: backgroundColor),
            date: date
        )
    }

}
