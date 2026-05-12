//
//  RatingsStore.swift
//  Joiefull
//
//  Created by Jaouad on 27/04/2026.
//

import Foundation
import Combine

/// Conserve en mémoire les notes et commentaires utilisateur pendant la session.

@MainActor
final class RatingsStore: ObservableObject {

    @Published private(set) var ratings:  [Int: Double] = [:]
    @Published private(set) var comments: [Int: String] = [:]

    func rating(for product: Product) -> Double {
        ratings[product.id] ?? 0
    }

    func comment(for product: Product) -> String {
        comments[product.id] ?? ""
    }

    func setRating(_ rating: Double, for product: Product) {
        ratings[product.id] = rating
    }

    func setComment(_ comment: String, for product: Product) {
        comments[product.id] = comment
    }
}
