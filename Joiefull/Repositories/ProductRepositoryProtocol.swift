//
//  ProductRepositoryProtocol.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//

import Foundation

protocol ProductRepositoryProtocol {
    func fetchProducts() async throws -> [Product]
}
