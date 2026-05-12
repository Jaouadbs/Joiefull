//
//  ProductRepository.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//
import Foundation

final class ProductRepository: ProductRepositoryProtocol, Sendable {

    private let apiURL = URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json")!

    func fetchProducts() async throws -> [Product] {
        
        let (data, response) = try await URLSession.shared.data(from: apiURL)
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([Product].self, from: data)
    }
}
