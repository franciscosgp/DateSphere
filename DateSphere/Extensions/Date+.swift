//
//  Date+.swift
//  DateSphere
//

import Foundation

// MARK: - [Extension] Date

extension Date {

    // MARK: Variables

    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Global.dateFormat
        return formatter.string(from: self)
    }

    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    var isInFuture: Bool {
        return self > Date()
    }

    var numberOfDays: Int {
        let calendar = Calendar.current
        let now = Date()
        if self > now {
            let components = calendar.dateComponents([.day], from: now, to: self)
            return components.day!
        } else {
            let components = calendar.dateComponents([.day], from: self, to: now)
            return components.day!
        }
    }

}
