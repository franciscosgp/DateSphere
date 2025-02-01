//
//  String+.swift
//  DSComponents
//

import Foundation

extension String {

    // MARK: Variables

    var localized: String {
        NSLocalizedString(self, bundle: .module, comment: "")
    }

}
