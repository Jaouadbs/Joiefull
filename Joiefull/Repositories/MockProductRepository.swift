//
//  MockProductRepository.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//

import Foundation

class MockProductRepository: ProductRepositoryProtocol {
    var productsToRetun: [Product] = [
        Product(id: 0,
                picture: ProductPicture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
                                        description: "Sac à main orange posé sur une poignée de porte"),
                name: "Sac à main orange",
                category: "ACCESSORIES",
                likes: 56,
                price: 69.99,
                originalPrice: 69.99),

        Product(id: 1,
                picture: ProductPicture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg",
                                        description: "Modèle femme qui porte un jean et un haut jaune"),
                name: "Jean pour femme",
                category: "BOTTOMS",
                likes: 55,
                price: 49.99,
                originalPrice: 59.99)
    ]
    var shouldThrowError = false

    func fetchProducts() async throws -> [Product] {
        if shouldThrowError {
            throw URLError(.notConnectedToInternet)
        }
        return productsToRetun
    }
}
