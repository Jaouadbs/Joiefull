//
//  EuroFormatted.swift
//  Joiefull
//
//  Created by Jaouad on 24/04/2026.
//

import Foundation

/// Formate un nombre décimal (Double) en prix en euros.

extension Double {
    // On le rend statique pour qu'il soit créé une seule fois en mémoire
    private static let cacheFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "EUR"
        f.locale = Locale(identifier: "fr_FR")
        return f
    }()

    var euroFormatted: String {
        return Self.cacheFormatter.string(from: NSNumber(value: self)) ?? "\(self) €"
    }
}
