//
//  ProductRepository.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//

import Foundation

class ProductRepository: ProductRepositoryProtocol {
    private let url = URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json")!
    func fetchProducts() async throws -> [Product] {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Product].self, from: data)
    }
}
