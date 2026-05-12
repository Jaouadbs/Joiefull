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

