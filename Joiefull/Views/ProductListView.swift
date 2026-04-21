//
//  ProductListView.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//

import SwiftUI
import Combine

struct ProductListView: View {
    @ObservedObject var viewModel : ProductListViewModel
    @Binding var selectedProduct : Product?

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView ("Chargement...")
                    .padding(.top, 50)
                    .accessibilityLabel("Chargement en cours")
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .padding()
                    .accessibilityLabel(error)
            } else {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.categoryOrder,id: \.self) {
                        category in
                        if let items = viewModel.groupedProducts [category], !items.isEmpty{
                            Section {
                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(items) { product in
                                        ProductCardView(product: product)
                                            .onTapGesture {
                                                selectedProduct = product
                                            }
                                            .accessibilityElement(children: .combine)
                                            .accessibilityLabel("\(product.name), \(product.price)€")
                                            .accessibilityHint("Double-Clic pour voir les détails")
                                    }
                                }
                                .padding(.horizontal)
                            } header: {
                                Text(viewModel.categoryDisplayName(category))
                                    .font(.title2.bold())
                                    .padding(.horizontal)
                                    .accessibilityAddTraits(.isHeader)
                            }
                        }
                    }
                }
                .padding(.top)
            }
        }
        .navigationTitle("Joiefull")
        .task {
            await viewModel.loadProducts()
        }
    }
}

#Preview {
    // Données statiques réalistes pour la preview
    let staticProducts = [
        Product(
            id: 0,
            picture: ProductPicture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg", description: "Sac à main orange posé sur une poignée de porte"),
            name: "Sac à main orange",
            category: "ACCESSORIES",
            likes: 56,
            price: 69.99,
            originalPrice: 69.99
        ),
        Product(
            id: 2,
            picture: ProductPicture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/shoes/1.jpg", description: "Modèle femme qui pose dans la rue en bottes de pluie noires"),
            name: "Bottes noires pour l'automne",
            category: "SHOES",
            likes: 4,
            price: 99.99,
            originalPrice: 119.99
        ),
        Product(
            id: 10,
            picture: ProductPicture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/3.jpg", description: "Pendentif rond bleu dans la main d'une femme"),
            name: "Pendentif bleu pour femme",
            category: "ACCESSORIES",
            likes: 70,
            price: 19.99,
            originalPrice: 29.99
        ),
        Product(
            id: 3,
            picture: ProductPicture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/1.jpg", description: "Homme en costume et veste de blazer qui regarde la caméra"),
            name: "Blazer marron",
            category: "TOPS",
            likes: 120,
            price: 89.99,
            originalPrice: 99.99
        ),
        Product(
            id: 1,
            picture: ProductPicture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg", description: "Modèle femme qui porte un jean et un haut jaune"),
            name: "Jean pour femme",
            category: "BOTTOMS",
            likes: 55,
            price: 49.99,
            originalPrice: 59.99
        ),
        Product(
            id: 78,
            picture: ProductPicture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg", description: "Modèle femme qui porte un jean et un haut jaune"),
            name: "Jean pour femme",
            category: "BOTTOMS",
            likes: 55,
            price: 49.99,
            originalPrice: 59.99
        ),
        Product(
            id: 4,
            picture: ProductPicture(url: "https://exemple.com/watch.jpg", description: "Montre élégante"),
            name: "Montre",
            category: "ACCESSORIES",
            likes: 203,
            price: 129.99,
            originalPrice: 149.99
        ),
    ]

    // ViewModel simplifié pour la preview
    let previewViewModel: ProductListViewModel = {
        let vm = ProductListViewModel(repository: PreviewProductRepository(products: staticProducts))
        // On simule le chargement terminé
        vm.isLoading = false
        vm.products = staticProducts
        return vm
    }()

    return NavigationStack {
        ProductListView(viewModel: previewViewModel, selectedProduct: .constant(nil))
    }
}

// Repository pour la preview uniquement
private struct PreviewProductRepository: ProductRepositoryProtocol {
    let products: [Product]

    func fetchProducts() async throws -> [Product] {
        products // Retourne directement les données statiques
    }
}
