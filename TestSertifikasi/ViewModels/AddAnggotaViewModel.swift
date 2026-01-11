//
//  AddAnggotaViewModel.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import Foundation
import Combine

@MainActor
final class AddAnggotaViewModel: ObservableObject {
    @Published var nama = ""
    @Published var alamat = ""
    @Published var noTelp = ""
    @Published var jenisKelamin: JenisKelamin = .lakiLaki

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var didSave = false

    enum JenisKelamin: String, CaseIterable, Identifiable {
        case lakiLaki = "Laki-laki"
        case perempuan = "Perempuan"

        var id: String { rawValue }
    }

    private let service: AnggotaService

    init(service: AnggotaService) {
        self.service = service
    }

    func save() async {
        let n = nama.trimmingCharacters(in: .whitespacesAndNewlines)
        let a = alamat.trimmingCharacters(in: .whitespacesAndNewlines)
        let t = noTelp.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !n.isEmpty else {
            errorMessage = "Nama wajib diisi."
            showError = true
            return
        }
        guard !t.isEmpty else {
            errorMessage = "No. Telp wajib diisi."
            showError = true
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await service.createAnggota(
                nama: n,
                alamat: a,
                noTelp: t,
                jenisKelamin: jenisKelamin.rawValue
            )
            didSave = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
