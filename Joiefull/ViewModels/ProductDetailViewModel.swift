//
//  ProductDetailViewModel.swift
//  Joiefull
//
//  Created by Jaouad on 22/04/2026.
//

import Foundation
import Combine

@MainActor
final class ProductDetailViewModel: ObservableObject {
    
    @Published var userRating: Double
    @Published var userComment: String
    @Published private(set) var isLiked: Bool
    @Published private(set) var localLikes: Int
    
    let product: Product
    
    
    private let favoritesStore: FavoritesStore
    private let ratingsStore: RatingsStore
    
    init(
        product: Product,
        favoritesStore: FavoritesStore,
        ratingsStore: RatingsStore
    ) {
        self.product = product
        self.favoritesStore = favoritesStore
        self.ratingsStore = ratingsStore
        self.userRating = ratingsStore.rating(for: product)
        self.userComment = ratingsStore.comment(for: product)
        self.isLiked = favoritesStore.isLiked(product)
        self.localLikes = favoritesStore.likesCount(for: product)
    }
    
    var hasDiscount: Bool {
        product.price < product.originalPrice
    }
    
    var shareText: String {
        var text = "Découvrez \"\(product.name)\" à \(product.price.euroFormatted) sur Joiefull"
        if !userComment.isEmpty {
            text += "\n\n\(userComment)"
        }
        return text
    }
    
    var likeAccessibilityLabel: String {
        let agreement = localLikes > 1 ? "personnes aiment" : "personne aime"
        return isLiked
        ? "Retirer le like — \(localLikes) \(agreement) cet article"
        : "Aimer cet article — \(localLikes) \(agreement) cet article"
    }
    
    var priceAccessibilityLabel: String {
        hasDiscount
        ? "Prix actuel \(product.price.euroFormatted), prix original \(product.originalPrice.euroFormatted)"
        : "Prix : \(product.price.euroFormatted)"
    }
    
    func toggleLike() {
        favoritesStore.toggleLike(for: product)
        isLiked = favoritesStore.isLiked(product)
        localLikes = favoritesStore.likesCount(for: product)
    }
    
    func submitRating(_ rating: Double) {
        userRating = rating
        ratingsStore.setRating(rating, for: product)
    }
    
    func updateComment(_ comment: String) {
        userComment = comment
        ratingsStore.setComment(comment, for: product)
    }
}
