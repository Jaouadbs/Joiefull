//
//  ProductCardView.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: product.picture.url)) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))

                }
                .aspectRatio(3/4,contentMode: .fit)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel(product.picture.description)

                // Badge Likes
                HStack(spacing: 4) {
                    Image(systemName: "heart")
                        .font(.caption)
                    Text("\(product.likes)")
                        .font(.caption.bold())
                }
                .padding(.horizontal,8)
                .padding(.vertical,4)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(8)
                .accessibilityLabel("\(product.likes) j'aime")
            }
            HStack {
                Text(product.name)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundStyle(.orange)
                    .font(.caption)
                Text(String(format: "%.1f", product.rating)) // Affiche la note en décimale
                    .font(.caption)

            }
            .accessibilityLabel("Note : \(String(format: "%.1f",product.rating)) étoiles")

            HStack{
               // VStack (alignment: .leading, spacing: 2) {
                    Text("\(String(format: "%.2f",product.price)) €")
                        .font(.headline)
                    Spacer()
                    if product.isOnSale {
                        Text("\(String(format: "%.2f",product.originalPrice)) €")
                            .font(.caption)
                            .strikethrough()
                            .foregroundStyle(.secondary)
                    }
            }
        }
    }
}

#Preview {
    // Produit statique pour la preview
    let previewProduct = Product(
        id: 1,
        picture: ProductPicture(
            url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg", // URL de test (remplace par une URL valide si tu veux voir l'image)
            description: "T-Shirt blanc en coton bio"
        ),
        name: "T-Shirt Blanc Oversize",
        category: "TOPS",
        likes: 128,
        price: 24.99,
        originalPrice: 34.99
    )

    return ProductCardView(product: previewProduct)
        .frame(width: 180) // Largeur typique pour une carte dans une grille
        .padding() // Pour voir le rendu avec un peu d'espace autour
}
