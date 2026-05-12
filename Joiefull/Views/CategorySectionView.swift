//
//  CategorySectionView.swift
//  Joiefull
//
//  Created by Jaouad on 28/04/2026.
//Composant intermédiaire qui structure les produits par section (Header + Grille) pour la liste principale

import SwiftUI

struct CategorySectionView: View {

    let category:        Product.Category
    let products:        [Product]
    let columns:         [GridItem]
    @Binding var selectedProduct: Product?

    // lecture explicite du store pour le passer à ProductCellView
    @EnvironmentObject private var favoritesStore: FavoritesStore

    var body: some View {
        Section {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(products) { product in

                    ProductCellView(
                        product:        product,
                        favoritesStore: favoritesStore,
                        selectedProduct: $selectedProduct
                    )
                }
            }
        } header: {
            Text(category.displayName)
                .font(.joieTitle)
                .foregroundStyle(Color.joieTextPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityAddTraits(.isHeader)
        }
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    let cols = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    let products = [
        Product(id: 1, name: "Veste en jean", category: .tops, likes: 12,
                price: 89.99, originalPrice: 89.99,
                picture: Product.Picture(
                    url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/1.jpg",
                    description: "Veste en jean")),
        Product(id: 15, name: "T-shirt Blanc", category: .tops, likes: 45,
                price: 19.99, originalPrice: 24.99,
                picture: Product.Picture(
                    url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/2.jpg",
                    description: "T-shirt blanc"))
    ]
    ScrollView {
        CategorySectionView(category: .tops, products: products,
                            columns: cols, selectedProduct: .constant(nil))
        .padding()
    }
    .environmentObject(FavoritesStore())
}
#endif
