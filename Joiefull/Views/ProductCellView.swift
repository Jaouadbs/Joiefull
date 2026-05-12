//
//  ProductCellView.swift
//  Joiefull
//
//  Created by Jaouad on 28/04/2026.
//

import SwiftUI

struct ProductCellView: View {

    @StateObject private var viewModel: ProductCellViewModel
    @Binding var selectedProduct: Product?

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dynamicTypeSize)     private var typeSize
    
    init(product: Product, favoritesStore: FavoritesStore, selectedProduct: Binding<Product?>) {
        _viewModel       = StateObject(wrappedValue: ProductCellViewModel(
            product:        product,
            favoritesStore: favoritesStore
        ))
        _selectedProduct = selectedProduct
    }

    var body: some View {
        if horizontalSizeClass == .regular { ipadCell } else { iphoneCell }
    }

    // MARK: - iPad

    private var ipadCell: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedProduct = viewModel.product
            }
        } label: {
            ProductCardView(
                product:    viewModel.product,
                likesCount: viewModel.likesCount,
                isLiked:    viewModel.isLiked,
                imageHeight: imageHeight
            )

        }
        .buttonStyle(.plain)

        .accessibilityLabel(viewModel.accessibilityLabel)
        .accessibilityHint("Double-tapez pour voir les détails de \(viewModel.product.name)")
    }

    // MARK: - iPhone

    private var iphoneCell: some View {
        NavigationLink(value: viewModel.product) {
            ProductCardView(
                product:     viewModel.product,
                likesCount:  viewModel.likesCount,
                isLiked:     viewModel.isLiked,
                imageHeight: imageHeight
            )
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            TapGesture().onEnded { selectedProduct = viewModel.product }
        )
        .accessibilityElement(children: .contain)
    }

    // MARK: - Computed

    private var isSelected: Bool { selectedProduct?.id == viewModel.product.id }

    private var selectionOverlay: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(isSelected ? Color.joieOrange : Color.clear, lineWidth: 2)
    }

    private var imageHeight: CGFloat {
        if typeSize >= .accessibility1 { return 120 }
        if typeSize >= .xxLarge        { return horizontalSizeClass == .regular ? 140 : 170 }
        return horizontalSizeClass == .regular ? 160 : 198
    }
}

// MARK: - Preview

#if DEBUG
private let _previewFav = FavoritesStore()
private let _previewProd = Product(
    id: 0, name: "Sac à main orange", category: .accessories,
    likes: 56, price: 69.99, originalPrice: 69.99,
    picture: Product.Picture(
        url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
        description: "Sac à main orange posé sur une poignée de porte"
    )
)

#Preview("iPhone") {
    NavigationStack {
        ProductCellView(product: _previewProd, favoritesStore: _previewFav,
                        selectedProduct: .constant(nil))
        .padding()
    }
}

#Preview("iPhone — Dynamic Type XXL") {
    NavigationStack {
        ProductCellView(product: _previewProd, favoritesStore: _previewFav,
                        selectedProduct: .constant(nil))
        .padding()
    }
    .dynamicTypeSize(.xxxLarge)
}

#Preview("iPad — sélectionné") {
    ProductCellView(product: _previewProd, favoritesStore: _previewFav,
                    selectedProduct: .constant(_previewProd))
    .padding()
    .previewDevice("iPad Pro (12.9-inch) (6th generation)")
}
#endif
