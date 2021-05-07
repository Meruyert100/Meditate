//
//  Helper.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 5/4/21.
//

import Foundation

struct Helper {
    static var selectedLanguage = "en"
    
    static func translate(title: String, lang: String) -> String {
        return title.addLocalizableString(str: lang)
    }
}

