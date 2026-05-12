//
//  ProductCellViewModel.swift
//  Joiefull
//
//  Created by Jaouad on 04/05/2026.
//

import Foundation
import Combine

@MainActor
final class ProductCellViewModel: ObservableObject {
    
    @Published private(set) var isLiked: Bool
    @Published private(set) var likesCount: Int
    
    let product: Product
    
    
    private let favoritesStore: FavoritesStore
    
    init(
        product: Product,
        favoritesStore: FavoritesStore
    ) {
        self.product = product
        self.favoritesStore = favoritesStore
        self.isLiked = favoritesStore.isLiked(product)
        self.likesCount = favoritesStore.likesCount(for: product)
    }
    
    func toggleLike() {
        favoritesStore.toggleLike(for: product)
        isLiked = favoritesStore.isLiked(product)
        likesCount = favoritesStore.likesCount(for: product)
    }
    
    var accessibilityLabel: String {
        var desc = "\(product.name), \(product.price.euroFormatted)"
        if product.isOnSale {
            desc += ", prix original \(product.originalPrice.euroFormatted)"
        }
        desc += ", \(likesCount) j'aime"
        if isLiked {
            desc += ", article aimé"
        }
        return desc
    }
}
