//
//  ProductListViewModel.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//

import Foundation
import Combine

@MainActor
final class ProductListViewModel: ObservableObject {
    
    @Published var groupedProducts: [Product.Category: [Product]] = [:]
    @Published var isLoading  = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    private let repository: ProductRepositoryProtocol
    
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    
    static func makeDefault() -> ProductListViewModel {
        ProductListViewModel(repository: ProductRepository())
    }
    
    var filteredGroupedProducts: [Product.Category: [Product]] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return groupedProducts
        }
        let query = searchText.lowercased()
        var result: [Product.Category: [Product]] = [:]
        for (category, products) in groupedProducts {

            let filtered = products.filter {
                $0.name.lowercased().contains(query) ||
                $0.category.displayName.lowercased().contains(query)
            }
            if !filtered.isEmpty { result[category] = filtered }
        }
        return result
    }
    
    var sortedCategories: [Product.Category] {
        filteredGroupedProducts.keys.sorted { $0.sortOrder < $1.sortOrder }
    }
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            let products = try await repository.fetchProducts()
            groupedProducts = Dictionary(grouping: products, by: { $0.category })
        } catch {
            errorMessage = "Impossible de charger les articles. Vérifiez votre connexion."
        }
        isLoading = false
    }
}
