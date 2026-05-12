//
//  Product.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//

import Foundation

struct Product: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let name: String
    let category: Category
    let likes: Int
    let price: Double
    let originalPrice: Double
    let picture: Picture
    
    enum Category: String, Codable, CaseIterable, Hashable {
        case tops        = "TOPS"
        case bottoms     = "BOTTOMS"
        case shoes       = "SHOES"
        case accessories = "ACCESSORIES"
        
        var displayName: String {
            switch self {
            case .tops:        return "Hauts"
            case .bottoms:     return "Bas"
            case .shoes:       return "Chaussures"
            case .accessories: return "Accessoires"
            }
        }
        
        var sortOrder: Int {
            switch self {
            case .tops:        return 0
            case .bottoms:     return 1
            case .shoes:       return 2
            case .accessories: return 3
            }
        }
    }
    
    struct Picture: Codable, Equatable, Hashable {
        let url: String
        let description: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, likes, price, picture
        case originalPrice = "original_price"
    }
}

// MARK: - Computed properties

extension Product {
    // Description textuelle = alt text fourni par l'API
    var productDescription: String {
        picture.description
    }
    
    // Note simulée depuis les likes (l'API ne fournit pas de note)
    var displayRating: Double {
        let normalized = min(Double(likes) / 70.0, 1.0)
        return (3.5 + normalized * 1.5).rounded(toPlaces: 1)
    }
    var isOnSale: Bool { price < originalPrice }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
