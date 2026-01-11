//
//  PetugasAuthViewModel.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import Foundation
import Combine

@MainActor
final class PetugasAuthViewModel: ObservableObject {

    // MARK: - Input
    @Published var username: String = ""
    @Published var password: String = ""

    // MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Output (login success)
    @Published var petugas: Petugas?

    func login() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let res = try await PetugasService.login(
                username: username,
                password: password
            )

            guard res.ok else {
                errorMessage = res.message ?? "Login gagal"
                return
            }

            guard let id = res.idPetugas,
                  let username = res.username else {
                errorMessage = "Response login tidak lengkap"
                return
            }

            petugas = Petugas(id: id, username: username)

            password = ""
        } catch {
            errorMessage = "Login gagal: \(error.localizedDescription)"
        }
    }

    func logout() {
        petugas = nil
        username = ""
        password = ""
        errorMessage = nil
    }
}
