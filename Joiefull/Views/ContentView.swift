//
//  ContentView.swift
//  Joiefull
//
//  Created by Jaouad on 16/04/2026.
//

import SwiftUI

@MainActor
struct ContentView: View {
    @StateObject private var listViewModel = ProductListViewModel.makeDefault()
    @State private var selectedProduct: Product?
    @AccessibilityFocusState private var isDetailFocused: Bool
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject var favoritesStore: FavoritesStore
    @EnvironmentObject var ratingsStore: RatingsStore

    var body: some View {
        if horizontalSizeClass == .regular {
            ipadLayout
        } else {
            iphoneLayout
        }
    }

    // MARK: - iPhone
    private var iphoneLayout: some View {
        NavigationStack {
            ProductListView(
                viewModel: listViewModel,
                selectedProduct: $selectedProduct
            )
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(
                    viewModel: ProductDetailViewModel(
                        product: product,
                        favoritesStore: favoritesStore,
                        ratingsStore: ratingsStore
                    )
                )
                .accessibilityFocused($isDetailFocused)
                .onAppear {isDetailFocused = true}

            }
        }
    }

    // MARK: - iPad

    private var ipadLayout: some View {
        NavigationStack {
            GeometryReader { geo in
                // ZStack aligné à droite pour superposer le détail sur la liste
                ZStack(alignment: .trailing) {

                    // La liste prend TOUJOURS toute la largeur de l'écran.
                    // Les 5 colonnes resteront fixes et les images ne bougeront pas.
                    ProductListView(
                        viewModel: listViewModel,
                        selectedProduct: $selectedProduct
                    )
                    .frame(width: geo.size.width)

                    // Le panneau de détail vient se superposer
                    if let product = selectedProduct {
                        ProductDetailView(
                            viewModel: ProductDetailViewModel(
                                product: product,
                                favoritesStore: favoritesStore,
                                ratingsStore: ratingsStore
                            )
                        )
                        .id(product.id)
                        // Il prend 40% de l'écran (environ 2 colonnes sur 5)
                        .frame(width: geo.size.width * 0.40)
                        // un fond opaque pour masquer la liste en dessous
                        .background(Color(UIColor.systemBackground))
                        // Glisse depuis la droite
                        .transition(.move(edge: .trailing))
                        .accessibilityLabel("Détails du produit \(product.name)")
                        .accessibilityAddTraits(.isModal)
                        .onAppear {
                            UIAccessibility.post(
                                notification: .layoutChanged,
                                argument: "Détails de \(product.name) affichés"
                            )
                        }
                    }
                }
            }
            .navigationTitle("Joiefull")
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $listViewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Rechercher un article"
            )
            // Bouton fermer dans la toolbar principale
            .toolbar {
                if selectedProduct != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedProduct = nil
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(.secondary)
                        }
                        .accessibilityLabel("Fermer le détail")
                        .accessibilityHint("Retourne à la liste des produits")
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedProduct != nil)
        }
    }
}
#if DEBUG
#Preview("iPhone") {
    ContentView()
        .environmentObject(FavoritesStore())
        .environmentObject(RatingsStore())
}

#Preview("iPad", traits: .landscapeLeft) {
    ContentView()
        .environment(\.horizontalSizeClass, .regular)
        .environmentObject(FavoritesStore())
        .environmentObject(RatingsStore())
}
#endif

