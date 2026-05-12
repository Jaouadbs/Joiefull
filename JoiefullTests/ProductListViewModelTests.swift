//
//  ProductListViewModelTests.swift
//  JoiefullTests
//
//  Created by Jaouad on 05/05/2026.
//


import XCTest
@testable import Joiefull

@MainActor
final class ProductListViewModelTests: XCTestCase {

    private var mockRepo: MockProductRepository!
    private var sut:      ProductListViewModel!

    override func setUp() {
        super.setUp()
        mockRepo = MockProductRepository()
        sut      = ProductListViewModel(repository: mockRepo)
    }

    override func tearDown() {
        sut      = nil
        mockRepo = nil
        super.tearDown()
    }


    // MARK: - Chargement des produits


    func test_chargement_succes() async {
        mockRepo.stubbedProducts = MockData.tousLesProduits

        await sut.loadProducts()

        XCTAssertFalse(sut.groupedProducts.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_chargement_erreurReseau() async {
        mockRepo.shouldThrow = true

        await sut.loadProducts()

        XCTAssertTrue(sut.groupedProducts.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
    }

    func test_chargement_appelle_repositoryUneFois() async {
        await sut.loadProducts()
        XCTAssertEqual(mockRepo.fetchCallCount, 1)
    }


    // MARK: - Groupement par catégorie

    func test_groupement_categoriesCorrects() async {
        mockRepo.stubbedProducts = MockData.tousLesProduits

        await sut.loadProducts()

        // On vérifie que les catégories attendues sont présentes
        XCTAssertNotNil(sut.groupedProducts[.tops])
        XCTAssertNotNil(sut.groupedProducts[.bottoms])
        XCTAssertNotNil(sut.groupedProducts[.shoes])
        XCTAssertNotNil(sut.groupedProducts[.accessories])
    }

    // MockData.produitsTops contient seulement 2 Hauts
    func test_groupement_seulementLesTops() async {
        mockRepo.stubbedProducts = MockData.produitsTops

        await sut.loadProducts()

        XCTAssertEqual(sut.groupedProducts[.tops]?.count, 2)
        XCTAssertNil(sut.groupedProducts[.bottoms]) // pas de bas
    }


    // MARK: - Ordre des catégories

    func test_ordre_categoriesTrieesCorrectement() async {
        mockRepo.stubbedProducts = MockData.tousLesProduits

        await sut.loadProducts()

        let ordres = sut.sortedCategories.map { $0.sortOrder }
        // Vérifie que la liste est triée (chaque élément <= au suivant)
        XCTAssertEqual(ordres, ordres.sorted())
    }


    // MARK: - Recherche

    func test_recherche_blazer_retourneUnSeulResultat() async {
        mockRepo.stubbedProducts = MockData.tousLesProduits

        await sut.loadProducts()

        //  "Blazer" correspond à MockData.blazer uniquement
        sut.searchText = "Blazer"

        let resultats = sut.filteredGroupedProducts.values.flatMap { $0 }
        XCTAssertEqual(resultats.count, 1)
        XCTAssertEqual(resultats.first?.name, MockData.blazer.name)
    }

    func test_recherche_vide_retourneTout() async {
        mockRepo.stubbedProducts = MockData.tousLesProduits

        await sut.loadProducts()
        sut.searchText = ""

        let total = sut.filteredGroupedProducts.values.flatMap { $0 }.count
        XCTAssertEqual(total, MockData.tousLesProduits.count) // 5
    }

    func test_recherche_sansResultat() async {
        mockRepo.stubbedProducts = MockData.tousLesProduits

        await sut.loadProducts()
        sut.searchText = "XYZXYZ"

        XCTAssertTrue(sut.filteredGroupedProducts.isEmpty)
    }
}
