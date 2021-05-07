//
//  String + Extension.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 5/4/21.
//

import Foundation

extension String {
    func addLocalizableString(str: String) -> String {
        let path = Bundle.main.path(forResource: str, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: "", bundle: bundle!, value: "", comment: "")
    }
}
