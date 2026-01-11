//
//  AnggotaService.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import Foundation
import Supabase

final class AnggotaService {
    private let client: SupabaseClient

    init(client: SupabaseClient) {
        self.client = client
    }

    func createAnggota(
        nama: String,
        alamat: String,
        noTelp: String,
        jenisKelamin: String
    ) async throws {
        try await client
            .from("anggota")
            .insert([
                "nama": nama,
                "alamat": alamat,
                "no_telp": noTelp,
                "jenis_kelamin": jenisKelamin
            ])
            .execute()
    }
}
