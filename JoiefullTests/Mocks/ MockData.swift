//
//    MockData.swift
//  JoiefullTests
//
//  Created by Jaouad on 07/05/2026.
// Ce fichier contient tous les produits fictifs utilisés dans les tests.

import Foundation

@testable import Joiefull

// MARK: - Produits fictifs

enum MockData {
    
    // ── Un produit sans promotion
    static let blazer = Product(
        id:            1,
        name:          "Blazer marron",
        category:      .tops,
        likes:         15,
        price:         79.99,
        originalPrice: 79.99,               
        picture: Product.Picture(
            url:         "https://example.com/blazer.jpg",
            description: "Homme en blazer marron qui regarde la caméra"
        )
    )
    
    // ── Un produit en promotion (prix barré)
    static let pullEnPromo = Product(
        id:            2,
        name:          "Pull torsadé",
        category:      .tops,
        likes:         56,
        price:         69.99,
        originalPrice: 95.00,               // prix original plus élevé = promo
        picture: Product.Picture(
            url:         "https://example.com/pull.jpg",
            description: "Femme avec un pull vert torsadé"
        )
    )
    
    // ── Un produit avec beaucoup de likes
    static let sacMain = Product(
        id:            3,
        name:          "Sac à main orange",
        category:      .accessories,
        likes:         70,
        price:         69.99,
        originalPrice: 99.99,
        picture: Product.Picture(
            url:         "https://example.com/sac.jpg",
            description: "Sac à main orange posé sur une poignée de porte"
        )
    )
    
    // ── Un produit avec peu de likes
    static let bottesNoires = Product(
        id:            4,
        name:          "Bottes noires",
        category:      .shoes,
        likes:         4,
        price:         99.99,
        originalPrice: 119.99,
        picture: Product.Picture(
            url:         "https://example.com/bottes.jpg",
            description: "Modèle femme en bottes noires"
        )
    )
    
    // ── Un jean (catégorie bas)
    static let jean = Product(
        id:            5,
        name:          "Jean pour femme",
        category:      .bottoms,
        likes:         55,
        price:         49.99,
        originalPrice: 59.99,
        picture: Product.Picture(
            url:         "https://example.com/jean.jpg",
            description: "Modèle femme qui porte un jean"
        )
    )
    
    // ── Liste complète de produits (pour tester le chargement de la liste)
    static let tousLesProduits: [Product] = [
        blazer,
        pullEnPromo,
        sacMain,
        bottesNoires,
        jean
    ]
    
    // ── Liste filtrée (seulement les Hauts)
    static let produitsTops: [Product] = [
        blazer,
        pullEnPromo
    ]
}
