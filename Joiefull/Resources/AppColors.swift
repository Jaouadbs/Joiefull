//
//  AppColors.swift
//  Joiefull
//
//  Created by Jaouad on 23/04/2026.
//


import SwiftUI

// MARK: - Palette de couleurs Joiefull

@MainActor
extension Color {

    // ── Textes
    static let joieTextPrimary   = Color.primary                 // noir ↔ blanc
    static let joieTextSecondary = Color.secondary               // gris
    static let joieTextTertiary  = Color(UIColor.tertiaryLabel)  // gris plus clair

    // ── Fonds

    static let joieBackground    = Color(UIColor.systemBackground) //blanc en clair, noir en sombre
    static let joieBackgroundAlt = Color(UIColor.secondarySystemBackground) // fond liste catalogue ≈ #F2F2F7 en clair (très proche du fond  ≈ #F0F0F5

    // ── Orange Joiefull (couleur principale de l'App)
    static let joieOrange     = Color.adaptive(light: "F5820A", dark: "FF9F43") // CTA
    static let joieOrangeSoft = Color.adaptive(light: "FFF0E0", dark: "3A2010") //fond teinté léger (ex: badge promo)
    static let joieSplash     = Color(hex: "F99F43") // barre nav + splash —fixe (#F99F43)


    // ── Interactions
    static let joieHeartActive = Color.adaptive(light: "FF3B30", dark: "FF6B6B") // coeur aimé
    static let joieStarFill    = Color.adaptive(light: "F99F43", dark: "FFB84D") // étoile remplie
    static let joieStarEmpty   = Color(UIColor.tertiaryLabel)                    // étoile vide

    // ── Prix
    static let joiePriceMain = Color.primary                                   // prix actuel
    static let joiePriceSale = Color.adaptive(light: "767676", dark: "A0A0A0") // prix barré

    // ── Composants
    //static let joieDivider     = Color(UIColor.separator)        // ligne de séparation adaptative
    static let joieLikeBadgeBg = Color(UIColor.systemBackground) // fond du badge cœur
    static let joieAreaComment = Color(UIColor.separator)        // bordure du champ commentaire


    // MARK: - Fonctions utilitaires

    /// Retourne une couleur différente selon le mode (clair ou sombre).

    static func adaptive(light: String, dark: String) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: dark)
                : UIColor(hex: light)
        })
    }

    /// Crée une couleur depuis un code hexadécimal

    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var intValue: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&intValue)

        let red   = Double((intValue >> 16) & 0xFF) / 255
        let green = Double((intValue >>  8) & 0xFF) / 255
        let blue  = Double(intValue         & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}

// MARK: - UIColor depuis un code hexadécimal

private extension UIColor {
    convenience init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var intValue: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&intValue)

        let red   = CGFloat((intValue >> 16) & 0xFF) / 255
        let green = CGFloat((intValue >>  8) & 0xFF) / 255
        let blue  = CGFloat(intValue         & 0xFF) / 255

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}


// MARK: - Polices — Dynamic Type

extension Font {
    static let joieTitle   = Font.title2.bold()  // titre de section
    static let joieTitle2  = Font.headline        // navigation / sous-titre
    static let joieBody    = Font.body            // noms produit, prix en liste
    static let joieStar    = Font.title2          // étoile / note de la fiche
    static let joieBadge   = Font.footnote        // compteurs like / commentaires
    static let joieSmall   = Font.caption         // texte auxiliaire
    static let joiePriceLg = Font.title2          // prix principal fiche produit
    static let joiePriceSm = Font.callout         // prix barré fiche produit — 16pt
}
