//
//  ContentView.swift
//  Joiefull
//
//  Created by Jaouad on 16/04/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var listVM = ProductListViewModel()
    @State private var selectedProduct: Product?

    var body: some View {
        NavigationStack {
            ProductListView(viewModel: listVM, selectedProduct: $selectedProduct)
                }

        }
    }


#Preview {
    ContentView()
}
