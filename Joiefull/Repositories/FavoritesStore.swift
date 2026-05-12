//
//  FavoritesStore.swift
//  Joiefull
//
//  Created by Jaouad on 27/04/2026.
//

import Foundation
import Combine

/// Conserve en mémoire les likes utilisateur pendant la session.

@MainActor
final class FavoritesStore: ObservableObject {

    @Published private(set) var likedProductIds: Set<Int> = []

    func isLiked(_ product: Product) -> Bool {
        likedProductIds.contains(product.id)
    }

    func toggleLike(for product: Product) {
        if likedProductIds.contains(product.id) {
            likedProductIds.remove(product.id)
        } else {
            likedProductIds.insert(product.id)
        }
    }

    func likesCount(for product: Product) -> Int {
        isLiked(product) ? product.likes + 1 : product.likes
    }
}

