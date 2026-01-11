//
//  DashboardPetugasViewModel.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import Foundation
import Combine

@MainActor
final class DashboardPetugasViewModel: ObservableObject {
    @Published var list: [Transaksi] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: TransaksiService

    init(service: TransaksiService) {
        self.service = service
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            list = try await service.fetchDashboard()
        } catch {
            errorMessage = "Gagal load data: \(error.localizedDescription)"
        }
    }

    func tapCheck(_ item: Transaksi) async {
        guard item.status == .dipinjam else { return }

        // Optimistic UI biar langsung berubah
        if let idx = list.firstIndex(where: { $0.id == item.id }) {
            list[idx] = Transaksi(
                id: item.id,
                idAnggota: item.idAnggota,
                idBuku: item.idBuku,
                idPetugas: item.idPetugas,
                namaAnggota: item.namaAnggota,
                alamatAnggota: item.alamatAnggota,
                noTelpAnggota: item.noTelpAnggota,
                judulBuku: item.judulBuku,
                tanggalPinjam: item.tanggalPinjam,
                tanggalJatuhTempo: item.tanggalJatuhTempo,
                tanggalPengembalian: Date(),
                status: .selesai
            )
        }

        do {
            try await service.markReturned(idData: item.id)
        } catch {
            // rollback: reload biar konsisten
            await load()
            errorMessage = "Gagal update pengembalian: \(error.localizedDescription)"
        }
    }
}

