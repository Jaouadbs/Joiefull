//
//  ProductCellViewModelTests.swift
//  JoiefullTests
//
//  Created by Jaouad on 05/05/2026.
//


import XCTest
@testable import Joiefull

@MainActor
final class ProductCellViewModelTests: XCTestCase {

    // MARK: - Helpers

    private func makeSUT(
        product: Product = MockData.blazer,
        store: FavoritesStore? = nil
    ) -> ProductCellViewModel {

        let store = store ?? FavoritesStore()
        return ProductCellViewModel(
            product: product,
            favoritesStore: store
        )
    }

    // MARK: - État initial

    func test_initialState_notLiked() {
        let sut = makeSUT()

        XCTAssertFalse(sut.isLiked)
        XCTAssertEqual(sut.likesCount, 15)
    }

    func test_initialState_alreadyLiked() {
        
        let store = FavoritesStore()
        store.toggleLike(for: MockData.blazer)

        let sut = makeSUT(store: store)

        XCTAssertTrue(sut.isLiked)
        XCTAssertEqual(sut.likesCount, 16)
    }

    // MARK: - Like

    func test_toggleLike_updatesStore() {
        let store = FavoritesStore()
        let sut = makeSUT(store: store)

        sut.toggleLike()

        XCTAssertTrue(store.isLiked(MockData.blazer))
    }

    func test_toggleLike_twice_removesLike() {
        let store = FavoritesStore()
        let sut = makeSUT(store: store)

        sut.toggleLike()
        sut.toggleLike()

        XCTAssertFalse(store.isLiked(MockData.blazer))
    }

    // MARK: - Accessibilité

    func test_accessibilityLabel_containsProductName() {
        let sut = makeSUT()
        XCTAssertTrue(sut.accessibilityLabel.contains("Blazer marron"))
    }

    func test_accessibilityLabel_discount_mentionsOriginalPrice() {
        let sut = makeSUT(product: MockData.pullEnPromo)
        XCTAssertTrue(sut.accessibilityLabel.contains("prix original"))
    }
}
