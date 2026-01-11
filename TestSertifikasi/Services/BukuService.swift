//
//  BukuService.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import Supabase

struct BukuService {
    static func fetchBuku() async throws -> [Buku] {
        try await supabase
            .from("buku")
            .select()
            .execute()
            .value
    }
}
