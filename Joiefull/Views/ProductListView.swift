//
//  ProductListView.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//

import SwiftUI

struct ProductListView: View {

    @ObservedObject var viewModel: ProductListViewModel
    @Binding var selectedProduct: Product?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    // MARK: - Colonnes
    // iPad  : 5 colonnes
    // iPhone: 2 colonnes

    private var columns: [GridItem] {
        let count = horizontalSizeClass == .regular  ? 5 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 12, alignment: .top), count : count)
    }

    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.errorMessage {
                errorView(message: error)
            } else if viewModel.sortedCategories.isEmpty && !viewModel.searchText.isEmpty {
                emptySearchView
            } else {
                productList
            }
        }
        // Titre et barre de recherche gérés dans ContentView pour iPad
        // et ici pour iPhone
        .ifCondition(horizontalSizeClass != .regular) { view in
            view
                .navigationTitle("Joiefull")
                .navigationBarTitleDisplayMode(.large)
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Rechercher un article"
                )
        }
        .task {
            if viewModel.groupedProducts.isEmpty {
                await viewModel.loadProducts()
            }
        }
    }

    // MARK: - Product List

    private var productList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                ForEach(viewModel.sortedCategories, id: \.self) { category in
                    if let products = viewModel.filteredGroupedProducts[category] {
                        CategorySectionView(
                            category: category,
                            products: products,
                            columns: columns,
                            selectedProduct: $selectedProduct
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.joieBackground)
    }

    // MARK: - Loading

    private var emptySearchView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(Color.joieOrangeSoft)
                .accessibilityHidden(true)
            Text("Aucun résultat pour \"\(viewModel.searchText)\"")
                .font(.joieBody)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Loading

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)

            Text("Chargement des articles...")
                .font(.joieBody)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityLabel("Chargement en cours")
    }

    // MARK: - Error

    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 48))
                .foregroundStyle(Color.joieOrange)
                .accessibilityHidden(true)

            Text(message)
                .font(.joieBody)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)

            Button("Réessayer") {
                Task { await viewModel.loadProducts() }}
                .buttonStyle(.borderedProminent)
                .tint(Color.joieOrange)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - View extension helper

extension View {
    @ViewBuilder
    func ifCondition<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {transform(self)
        } else {
            self
        }
    }
}

// MARK: - Preview

#if DEBUG
// DummyRepository dans #if DEBUG uniquement — ne compile pas en production
private final class DummyRepository: ProductRepositoryProtocol {
    func fetchProducts() async throws -> [Product] { [] }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ProductListViewModel(repository: DummyRepository())
        vm.groupedProducts = [
            .tops: [
                Product(id: 3, name: "Blazer marron", category: .tops, likes: 15,
                        price: 79.99, originalPrice: 79.99,
                        picture: Product.Picture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/1.jpg",
                                                 description: "Homme blazer")),
                Product(id: 4, name: "Pull vert femme", category: .tops, likes: 15,
                        price: 29.99, originalPrice: 39.99,
                        picture: Product.Picture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/2.jpg",
                                                 description: "Pull vert"))
            ]
        ]
        return NavigationStack {
            ProductListView(viewModel: vm, selectedProduct: .constant(nil))
        }
        .environmentObject(FavoritesStore())
    }
}
#endif
