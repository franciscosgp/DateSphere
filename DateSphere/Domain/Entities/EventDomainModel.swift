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
    let mainColor: Color?
    let secondaryColor: Color?
    let backgroundColor: Color?
    let date: Date
    var counter: Double

    var message: String {
        if date.isToday {
            return "today".localized
        } else if date.isTomorrow {
            return "tomorrow".localized
        } else if date.isYesterday {
            return "yesterday".localized
        } else if date.isInFuture {
            return String(format: "days_left".localized, String(date.numberOfDays))
        } else {
            return String(format: "days_ago".localized, String(date.numberOfDays))
        }
    }

    var milestonesMessage: String {
        switch counter {
        case .zero:
            return "no_milestones".localized
        case 1:
            return "one_milestone".localized
        default:
            return String(format: "several_milestones".localized, counter)
        }
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

    init(name: String, description: String?, iconName: String?, mainColor: Color?, secondaryColor: Color?, backgroundColor: Color?, date: Date, counter: Double) {
        self.objectId = nil
        self.name = name
        self.description = description
        self.iconName = iconName
        self.mainColor = mainColor
        self.secondaryColor = secondaryColor
        self.backgroundColor = backgroundColor
        self.date = date
        self.counter = counter
    }

}
