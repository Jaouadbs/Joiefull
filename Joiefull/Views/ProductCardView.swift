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

