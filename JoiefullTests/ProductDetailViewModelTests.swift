//
//  ProductDetailViewModelTests.swift
//  JoiefullTests
//
//  Created by Jaouad on 05/05/2026.
//


import XCTest
@testable import Joiefull

@MainActor
final class ProductDetailViewModelTests: XCTestCase {

    // MARK: - Helpers

    private func makeSUT(
        product: Product = MockData.blazer,
        favorites: FavoritesStore? = nil,
        ratings: RatingsStore? = nil
    ) -> ProductDetailViewModel {

        ProductDetailViewModel(
            product: product,
            favoritesStore: favorites ?? FavoritesStore(),
            ratingsStore: ratings ?? RatingsStore()
        )
    }

    // MARK: - État initial

    func test_initialState_defaultValues() {
        let sut = makeSUT()

        XCTAssertFalse(sut.isLiked)
        XCTAssertEqual(sut.localLikes, MockData.blazer.likes)
        XCTAssertEqual(sut.userRating, 0)
        XCTAssertEqual(sut.userComment, "")
    }

    func test_initialState_loadsExistingRating() {
        
        let ratings = RatingsStore()
        ratings.setRating(4.0, for: MockData.blazer)
        ratings.setComment("Très beau", for: MockData.blazer)

        let sut = makeSUT(ratings: ratings)

        XCTAssertEqual(sut.userRating, 4.0)
        XCTAssertEqual(sut.userComment, "Très beau")
    }

    // MARK: - Like

    func test_toggleLike_updatesState() {
        let favorites = FavoritesStore()
        let sut = makeSUT(favorites: favorites)

        sut.toggleLike()

        XCTAssertTrue(sut.isLiked)
        XCTAssertTrue(favorites.isLiked(MockData.blazer))
    }

    // MARK: - Notation

    func test_submitRating_persistsValue() {
        let ratings = RatingsStore()
        let sut = makeSUT(ratings: ratings)

        sut.submitRating(4.0)

        XCTAssertEqual(sut.userRating, 4.0)
        XCTAssertEqual(ratings.rating(for: MockData.blazer), 4.0)
    }

    func test_updateComment_persistsValue() {
        let ratings = RatingsStore()
        let sut = makeSUT(ratings: ratings)

        sut.updateComment("Super !")

        XCTAssertEqual(sut.userComment, "Super !")
        XCTAssertEqual(ratings.comment(for: MockData.blazer), "Super !")
    }

    // MARK: - Promotion

    func test_hasDiscount_pullEnPromo() {
        let sut = makeSUT(product: MockData.pullEnPromo)
        XCTAssertTrue(sut.hasDiscount)
    }

    func test_hasDiscount_blazerPasEnPromo() {
        let sut = makeSUT()
        XCTAssertFalse(sut.hasDiscount)
    }

    // MARK: - Texte de partage

    func test_shareText_withoutComment() {
        let sut = makeSUT()
        XCTAssertTrue(sut.shareText.contains(MockData.blazer.name))
        XCTAssertFalse(sut.shareText.contains("\n\n"))
    }

    func test_shareText_withComment() {
        let sut = makeSUT()
        sut.updateComment("Mon avis")
        XCTAssertTrue(sut.shareText.contains("\n\nMon avis"))
    }

    // MARK: - Labels accessibilité

    func test_priceLabel_avecPromotion() {
        let sut = makeSUT(product: MockData.pullEnPromo)
        XCTAssertTrue(sut.priceAccessibilityLabel.contains("Prix actuel"))
        XCTAssertTrue(sut.priceAccessibilityLabel.contains("prix original"))
    }

    func test_priceLabel_sansPromotion() {
        let sut = makeSUT()
        XCTAssertFalse(sut.priceAccessibilityLabel.contains("original"))
    }
}
