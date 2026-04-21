//
//  ProductListViewModel.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//

import Foundation
import Combine

@MainActor
class ProductListViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: ProductRepositoryProtocol

    init(repository: ProductRepositoryProtocol = ProductRepository()) {
        self.repository = repository
    }

    var groupedProducts : [String: [Product]] {
        Dictionary(grouping: products, by: { $0.category})
    }

    var categoryOrder: [String] {
        ["TOPS", "BOTTOMS","SHOES","ACCESSORIES"]
    }

    func categoryDisplayName(_ key: String) -> String {
        switch key {
        case "TOPS": return "Hauts"
        case "BOTTOMS": return "Bas"
        case "SHOES": return "Chaussures"
        case "ACCESSORIES": return "Accessoires"
        default: return key
        }
    }

    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            products = try await repository.fetchProducts()
        } catch {
            errorMessage = "Impossible de charger les articles."
        }
        isLoading = false
    }
}
