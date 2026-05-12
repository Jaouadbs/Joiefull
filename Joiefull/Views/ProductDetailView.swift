//
//  ProductDetailView.swift
//  Joiefull
//
//  Created by Jaouad on 22/04/2026.
//

import SwiftUI

struct ProductDetailView: View {

    @ObservedObject var viewModel: ProductDetailViewModel
    @Environment(\.dismiss)             private var dismiss
    @Environment(\.dynamicTypeSize)     private var dynamicTypeSize
    @Environment(\.verticalSizeClass)   private var verticalSizeClass
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    // lecture du contraste pour adapter les épaisseurs/couleurs
    @Environment(\.colorSchemeContrast) private var contrast
    // le cercle avatar suit Dynamic Type
    @ScaledMetric(relativeTo: .body) private var avatarSize: CGFloat = 40

    private var imageHeight: CGFloat {
        if horizontalSizeClass == .regular && verticalSizeClass == .compact { return 220 }
        switch dynamicTypeSize {
        case .xSmall, .small, .medium:          return 380
        case .large, .xLarge:                   return 340
        case .xxLarge, .xxxLarge:               return 300
        case .accessibility1, .accessibility2:  return 260
        case .accessibility3, .accessibility4,
             .accessibility5:                   return 220
        @unknown default:                       return 340
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                imageSection
                contentSection
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.joieBackground)
        .navigationBarBackButtonHidden(horizontalSizeClass == .compact)
        .toolbar {
            if horizontalSizeClass == .compact {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left").fontWeight(.semibold)
                            Text("Home")
                        }
                        .foregroundStyle(Color.accentColor)
                    }
                    .accessibilityLabel("Home")
                    .accessibilityHint("Retourner à l'accueil")
                }
            }
        }
    }

    // MARK: - Image Section

    private var imageSection: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: URL(string: viewModel.product.picture.url)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: imageHeight)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                default:
                    Color.joieBackgroundAlt
                        .frame(height: imageHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(ProgressView())
                }
            }
            .accessibilityLabel(viewModel.product.picture.description)

            // Dégradé lisibilité
            LinearGradient(
                colors: [.black.opacity(0.3), .clear, .black.opacity(0.3)],
                startPoint: .top, endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .allowsHitTesting(false)
            .accessibilityHidden(true)

            // Bouton Like
            Button { viewModel.toggleLike() } label: {
                HStack(spacing: 6) {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .font(.title3.weight(.medium))
                        .foregroundStyle(viewModel.isLiked ? Color.joieHeartActive : Color.primary
                        )
                    Text("\(viewModel.localLikes)")
                        .font(.joieBody)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.primary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.joieLikeBadgeBg, in: Capsule())
            }
            .frame(minWidth: 44, minHeight: 44)
            .padding(12)
            .accessibilityLabel(viewModel.likeAccessibilityLabel)

            // Bouton Partage
            VStack {
                HStack {
                    Spacer()
                    ShareLink(item: viewModel.shareText) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.primary)
                            .frame(width: 40, height: 40)
                            .background(.thinMaterial, in: Circle())
                    }
                    .accessibilityLabel("Partager cet article")
                    .frame(minWidth: 44, minHeight: 44)
                    .padding(8)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Content Section

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Nom + Note
            HStack(alignment: .firstTextBaseline) {
                Text(viewModel.product.name)
                    .font(.joieTitle)
                    .foregroundStyle(Color.joieTextPrimary)
                Spacer(minLength: 8)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.joieStar)
                        .foregroundStyle(Color.joieStarFill)
                        .accessibilityHidden(true)
                    Text(String(format: "%.1f", viewModel.product.displayRating))
                        .font(.joieStar)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.joieTextPrimary)
                }
            }
            .accessibilityElement(children: .combine)

            // Prix
            HStack(alignment: .firstTextBaseline) {
                Text(viewModel.product.price.euroFormatted)
                    .font(.joiePriceLg)
                    .foregroundStyle(Color.joiePriceMain)
                Spacer()
                if viewModel.hasDiscount {
                    Text(viewModel.product.originalPrice.euroFormatted)
                        .font(.joiePriceSm)
                        .foregroundStyle(Color.joiePriceSale)
                        .strikethrough(true, color: Color.joiePriceSale)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(viewModel.priceAccessibilityLabel)

            // Description
            Text(viewModel.product.productDescription)
                .font(.joieBody)
                .foregroundStyle(Color.joieTextPrimary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 4)

            // Zone notation : avatar + étoiles
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.joieOrangeSoft)
                    .frame(width: avatarSize, height: avatarSize)
                    .overlay(Image(systemName:"person.fill").foregroundStyle(Color.joieOrange)
                    )
                    .accessibilityHidden(true)

                StarRatingView(rating: $viewModel.userRating)
                    .onChange(of: viewModel.userRating) { _, newValue in
                        viewModel.submitRating(newValue)
                    }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Notation du produit")

            // Champ commentaire
            TextField("Partagez ici vos impressions sur cette pièce",
                      text: $viewModel.userComment,
                      axis: .vertical
            )
                .onChange(of: viewModel.userComment) { _,newValue in
                    viewModel.updateComment(newValue)
                }
                .lineLimit(3...6)
                .padding(12)
                .font(.joieBody)
                .foregroundStyle(Color.joieTextPrimary)
                .background(Color.joieBackground)
                .overlay(RoundedRectangle(cornerRadius:12).stroke(Color.joieAreaComment, lineWidth: contrast == .increased ? 1.5 : 1)
                )
                .accessibilityLabel("Champ de commentaire")
                .accessibilityHint("Entrez vos impressions sur cet article")
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 32)
    }
}

// MARK: - StarRatingView

struct StarRatingView: View {
    @Binding var rating: Double

    // lecture du mode pour adapter les étoiles
        @Environment(\.colorSchemeContrast) private var contrast

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { star in
                let filled = Double(star) <= rating
                Button {
                    rating = (Int(rating) == star) ? 0.0 :Double(star)
                } label: {
                    Image(systemName: filled ? "star.fill" : "star")
                        .font(.joieStar)
                        .foregroundStyle(filled ? Color.joieStarFill : Color.joieStarEmpty)
                        .frame(minWidth: 44, minHeight: 44)
                }

                .accessibilityLabel("\(star) étoile\(star > 1 ? "s" : "") sur 5")
                .accessibilityAddTraits(filled ? [.isSelected] : [])
                .accessibilityValue(filled ? "sélectionnée" : "")
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Votre note : \(Int(rating)) étoile\(rating >= 2 ? "s" : "") sur 5")
    }
}

// MARK: - Preview
#if DEBUG
private let _disc = Product(id: 4, name: "Pull torsadé", category: .tops,
    likes: 56, price: 69.99, originalPrice: 95.00,
    picture: .init(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/2.jpg",
                   description: "Femme dehors qui pose avec un pull en maille vert"))
private let _full = Product(id: 3, name: "Blazer marron", category: .tops,
    likes: 15, price: 79.99, originalPrice: 79.99,
    picture: .init(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/1.jpg",
                   description: "Homme en costume et veste de blazer qui regarde la caméra"))

#Preview("Avec remise — iPhone") {
    NavigationStack {
        ProductDetailView(viewModel: ProductDetailViewModel(
            product: _disc, favoritesStore: FavoritesStore(), ratingsStore: RatingsStore()))
    }
}
#Preview("Sans remise — iPhone") {
    NavigationStack {
        ProductDetailView(viewModel: ProductDetailViewModel(
            product: _full, favoritesStore: FavoritesStore(), ratingsStore: RatingsStore()))
    }
}
#Preview("iPad", traits: .landscapeLeft) {
    NavigationStack {
        ProductDetailView(viewModel: ProductDetailViewModel(
            product: _disc, favoritesStore: FavoritesStore(), ratingsStore: RatingsStore()))
    }
}
struct StatefulPreviewWrapper<V, C: View>: View {
    @State private var value: V
    private let content: (Binding<V>) -> C
    init(_ v: V, @ViewBuilder content: @escaping (Binding<V>) -> C) { _value = State(initialValue: v); self.content = content }
    var body: some View { content($value) }
}
#Preview("StarRatingView") {
    StatefulPreviewWrapper(0.0) { StarRatingView(rating: $0).padding() }
}
#endif
