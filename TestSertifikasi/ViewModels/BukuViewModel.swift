//
//  BukuViewModel.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//

import Foundation
import Combine

@MainActor
final class BukuViewModel: ObservableObject {
    @Published var daftarBuku: [Buku] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadBuku() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            daftarBuku = try await BukuService.fetchBuku()
        } catch {
            errorMessage = "Gagal ambil buku: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
}
