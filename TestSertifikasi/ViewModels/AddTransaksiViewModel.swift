//
//  AddTransaksiViewModel.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import Foundation
import Combine

@MainActor
final class AddTransaksiViewModel: ObservableObject {
    @Published var anggota: [TransaksiService.AnggotaListDTO] = []
    @Published var buku: [TransaksiService.BukuListDTO] = []

    @Published var selectedAnggotaId: Int64?
    @Published var selectedBukuId: Int64?

    @Published var tanggalPinjam: Date = Date()
    @Published var tanggalJatuhTempo: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var didSave = false

    private let service: TransaksiService
    private let idPetugas: Int64

    init(service: TransaksiService, idPetugas: Int64) {
        self.service = service
        self.idPetugas = idPetugas
    }

    func loadFormData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            async let a = service.fetchAnggotaList()
            async let b = service.fetchBukuTersediaList()
            let (anggotaList, bukuList) = try await (a, b)
            self.anggota = anggotaList
            self.buku = bukuList

            // auto-select pertama biar ga kosong
            if selectedAnggotaId == nil { selectedAnggotaId = anggotaList.first?.id_anggota }
            if selectedBukuId == nil { selectedBukuId = bukuList.first?.id_buku }

        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func save() async {
        guard let anggotaId = selectedAnggotaId else {
            errorMessage = "Pilih anggota dulu."
            showError = true
            return
        }
        guard let bukuId = selectedBukuId else {
            errorMessage = "Pilih buku dulu."
            showError = true
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await service.createTransaksi(
                idAnggota: anggotaId,
                idBuku: bukuId,
                idPetugas: idPetugas,
                tanggalPinjam: tanggalPinjam,
                tanggalJatuhTempo: tanggalJatuhTempo
            )
            didSave = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
