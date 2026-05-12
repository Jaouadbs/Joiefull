//
//  ProductCardView.swift
//  Joiefull
//
//  Created by Jaouad on 17/04/2026.
//

import SwiftUI

struct ProductCardView: View {

    let product: Product
    let likesCount: Int
    let isLiked: Bool
    // On garde uniquement la hauteur — la largeur s'adapte à la colonne
    let imageHeight: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            imageStack
            infoStack
        }
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.joieBackground))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityDescription)
        .accessibilityHint("Appuyez pour voir les détails")
    }

    // MARK: - Image + badge

    private var imageStack: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: URL(string: product.picture.url)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Color.joieBackgroundAlt
                        .overlay(Image(systemName: "photo")
                            .foregroundStyle(Color.joieTextTertiary)
                        )
                default:
                    Color.joieBackgroundAlt
                        .overlay(ProgressView())
                }
            }
            // maxWidth: .infinity -> s'adapte à la colonne, height fixe
            .frame(maxWidth: .infinity)
            .frame(height: imageHeight)
            // clipped avant clipShape pour éviter les débordements
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .accessibilityHidden(true)

            // Badge likes
            HStack(spacing: 4) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.caption2)
                    .foregroundStyle(isLiked ? Color.joieHeartActive : Color.joieTextPrimary)
                Text("\(likesCount)")
                    .font(.caption2)
                    .bold()
                    .foregroundStyle(Color.primary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.joieLikeBadgeBg, in: Capsule())
            .padding(8)
            .accessibilityHidden(true)
        }
    }

    // MARK: - Infos

    private var infoStack: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Nom + note
            HStack(alignment: .top) {
                Text(product.name)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .foregroundStyle(Color.joieTextPrimary)

                Spacer(minLength: 4)

                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(Color.joieStarFill)
                        .accessibilityHidden(true)
                    Text(String(format: "%.1f",product.displayRating))
                        .font(.caption)
                        .foregroundStyle(Color.joieTextPrimary)
                }
            }

            // Prix
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(product.price.euroFormatted)
                    .font(.footnote)
                    .foregroundStyle(Color.joieTextPrimary)

                Spacer()

                if product.isOnSale {
                    Text(product.originalPrice.euroFormatted)
                        .font(.caption)
                        .foregroundStyle(Color.joieTextSecondary)
                        .strikethrough(true, color: Color.joieTextSecondary)
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 6)
    }

    // MARK: - Accessibilité

    private var accessibilityDescription: String {
        var desc = "\(product.name), \(product.price.euroFormatted)"
        if product.isOnSale {
            desc += ", prix original \(product.originalPrice.euroFormatted)"
        }
        desc += ", \(likesCount) j'aime"
        if isLiked { desc += ", article aimé" }
        return desc
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Grille iPad 5 colonnes") {
    let products = [
        Product(id: 0, name: "Sac à main orange", category: .accessories,
                likes: 56, price: 69.99, originalPrice: 69.99,
                picture: Product.Picture(
                    url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
                    description: "Sac à main orange")),
        Product(id: 4, name: "Pull vert femme", category: .tops,
                likes: 15, price: 29.99, originalPrice: 39.99,
                picture: Product.Picture(
                    url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/2.jpg",
                    description: "Pull vert"))
    ]

    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)

    ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(products) { p in
                ProductCardView(
                    product: p,
                    likesCount: p.likes,
                    isLiked: false,
                    imageHeight: 160   // Hauteur adaptée à 5 col
                )
            }
        }
        .padding(16)
    }
}

#Preview("Carte iPhone") {
    HStack(spacing: 12) {
        ProductCardView(
            product: Product(id: 0, name: "Sac à main orange",
                             category: .accessories, likes: 56,
                             price: 69.99, originalPrice: 69.99,
                             picture: Product.Picture(
                                url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
                                description: "Sac à main orange")),
            likesCount: 56,
            isLiked: false,
            imageHeight: 198
        )
        ProductCardView(
            product: Product(id: 4, name: "Pull vert femme",
                             category: .tops, likes: 15,
                             price: 29.99, originalPrice: 39.99,
                             picture: Product.Picture(
                                url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/2.jpg",
                                description: "Pull vert")),
            likesCount: 16,
            isLiked: true,
            imageHeight: 198
        )
    }
    .padding()
}
#endif
