//
//  ContentView.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 09/01/26.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var vm = BukuViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Memuat buku...")
                } else if let error = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text(error)
                            .font(.footnote)
                            .multilineTextAlignment(.center)

                        Button("Coba lagi") {
                            Task { await vm.loadBuku() }
                        }
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(vm.daftarBuku) { buku in
                                BukuCard(buku: buku)
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Katalog Buku")
        }
        .task { await vm.loadBuku() }
    }
}


#Preview {
    ContentView()
}
