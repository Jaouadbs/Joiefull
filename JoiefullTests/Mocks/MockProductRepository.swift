//
//  MockProductRepository.swift
//  JoiefullTests
//
//  Created by Jaouad on 05/05/2026.
//


import Foundation
@testable import Joiefull

@MainActor
final class MockProductRepository: ProductRepositoryProtocol {
    
    var stubbedProducts: [Product] = []
    var shouldThrow = false
    private(set) var fetchCallCount = 0
    
    func fetchProducts() async throws -> [Product] {
        
        fetchCallCount += 1
        
        if shouldThrow {
            throw URLError(.notConnectedToInternet)
        }
        
        return stubbedProducts
    }
}
