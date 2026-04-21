//
//  Product.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//

import Foundation

struct ProductPicture: Codable {
    let url: String
    let description: String
}

struct Product: Codable, Identifiable {
    let id: Int
    let picture: ProductPicture
    let name: String
    let category: String
    let likes: Int
    let price: Double
    let originalPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case id, picture, name, category, likes, price
        case originalPrice = "original_price"
    }
    var isOnSale: Bool { price < originalPrice }
    
}
// Gstion de note de produit aléatoirement
extension Product {
    var rating: Double {
        return Double.random(in: 4.5...5.0).rounded(toPlaces: 1) // Note aléatoire entre 4.0 et 4.9
    }
}

// Extension pour arrondir à une décimale
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
