//
//  TransaksiService.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import Foundation
import Supabase

final class TransaksiService {
    private let client: SupabaseClient
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
//    // DTO mengikuti response Supabase (nested join)
//    private struct TransaksiRowDTO: Decodable {
//        let id_data: Int64
//        let id_anggota: Int64
//        let id_buku: Int64
//        let id_petugas: Int64
//        
//        let tanggal_pinjam: String
//        let tanggal_jatuh_tempo: String
//        let tanggal_pengembalian: String?
//        let status: String
//        
//        let anggota: AnggotaDTO?
//        let buku: BukuDTO?
//        
//        struct AnggotaDTO: Decodable { let nama: String }
//        struct BukuDTO: Decodable { let judul: String }
//    }
//    
    private let dateOnlyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    func fetchDashboard(limit: Int = 50) async throws -> [Transaksi] {
        
        struct PinjamDTO: Decodable {
            let id_data: Int64
            let id_anggota: Int64
            let id_buku: Int64
            let id_petugas: Int64
            
            let tanggal_pinjam: String
            let tanggal_jatuh_tempo: String
            let tanggal_pengembalian: String?
            let status: String
        }
        
        struct AnggotaDTO: Decodable {
            let id_anggota: Int64
            let nama: String
            let alamat: String
            let no_telp: String
        }
        
        struct BukuDTO: Decodable {
            let id_buku: Int64
            let judul: String
        }
        
        // MARK: - DTO list anggota & buku (untuk dropdown Add Transaksi)
        struct AnggotaListDTO: Decodable {
            let id_anggota: Int64
            let nama: String
        }
        
        // 1) Fetch transaksi (tanpa join)
        let pinjamRows: [PinjamDTO] = try await client
            .from("data_peminjaman")
            .select("""
                id_data,
                id_anggota,
                id_buku,
                id_petugas,
                tanggal_pinjam,
                tanggal_jatuh_tempo,
                tanggal_pengembalian,
                status
            """)
            .order("id_data", ascending: false)
            .limit(limit)
            .execute()
            .value
        
        print("PINJAM ROWS:", pinjamRows.count)
        if pinjamRows.isEmpty { return [] }
        
        // Ambil id unik
        let anggotaIds = Array(Set(pinjamRows.map { $0.id_anggota }))
        let bukuIds = Array(Set(pinjamRows.map { $0.id_buku }))
        
        // 2) Fetch anggota
        let anggotaRows: [AnggotaDTO] = try await client
            .from("anggota")
            .select("id_anggota, nama, alamat, no_telp")
            .in("id_anggota", values: anggotaIds.map { String($0) })
            .execute()
            .value
        
        
        // 3) Fetch buku
        let bukuRows: [BukuDTO] = try await client
            .from("buku")
            .select("id_buku, judul")
            .in("id_buku", values: bukuIds.map { String($0) })
            .execute()
            .value
        
        // Buat dictionary untuk lookup cepat
        let anggotaMap: [Int64: (nama: String, alamat: String, noTelp: String)] =
        Dictionary(uniqueKeysWithValues: anggotaRows.map {
            ($0.id_anggota, (nama: $0.nama, alamat: $0.alamat, noTelp: $0.no_telp))
        })
        let bukuMap = Dictionary(uniqueKeysWithValues: bukuRows.map { ($0.id_buku, $0.judul) })
        
        // 4) Gabungkan jadi model UI
        return pinjamRows.map { dto in
            let tPinjam = parseDate(dto.tanggal_pinjam)
            let tJatuhTempo = parseDate(dto.tanggal_jatuh_tempo)
            let tKembali = dto.tanggal_pengembalian.map { parseDate($0) }
            
            let statusLower = dto.status.lowercased()
            let status: StatusPeminjaman = (statusLower == "dipinjam") ? .dipinjam : .selesai
            
            let anggotaInfo = anggotaMap[dto.id_anggota]
            
            return Transaksi(
                id: dto.id_data,
                idAnggota: dto.id_anggota,
                idBuku: dto.id_buku,
                idPetugas: dto.id_petugas,
                namaAnggota: anggotaInfo?.nama ?? "(nama anggota tidak ditemukan)",
                alamatAnggota: anggotaInfo?.alamat ?? "-",
                noTelpAnggota: anggotaInfo?.noTelp ?? "-",
                judulBuku: bukuMap[dto.id_buku] ?? "(judul buku tidak ditemukan)",
                tanggalPinjam: tPinjam,
                tanggalJatuhTempo: tJatuhTempo,
                tanggalPengembalian: tKembali,
                status: status
            )
        }
    }
    
    func markReturned(idData: Int64) async throws {
        struct IdBukuDTO: Decodable {
            let id_buku: Int64
        }
        
        // 1) Ambil id_buku dari transaksi
        let rows: [IdBukuDTO] = try await client
            .from("data_peminjaman")
            .select("id_buku")
            .eq("id_data", value: String(idData))
            .limit(1)
            .execute()
            .value
        
        guard let idBuku = rows.first?.id_buku else {
            throw NSError(
                domain: "markReturned",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Transaksi tidak ditemukan"]
            )
        }
        
        let today = dateOnlyFormatter.string(from: Date())
        
        // 2) Update transaksi jadi selesai
        try await client
            .from("data_peminjaman")
            .update([
                "tanggal_pengembalian": today,
                "status": "selesai"
            ])
            .eq("id_data", value: String(idData))
            .execute()
        
        // 3) Update buku jadi tersedia lagi
        try await client
            .from("buku")
            .update(["tersedia": true])
            .eq("id_buku", value: String(idBuku))
            .execute()
    }
    
    
    private func parseDate(_ s: String) -> Date {
        // date column biasanya "yyyy-MM-dd"
        if let d = dateOnlyFormatter.date(from: s) { return d }
        
        // fallback kalau Supabase ngirim ada jam
        let iso = ISO8601DateFormatter()
        if let d = iso.date(from: s) { return d }
        
        // kalau gagal banget, pakai today biar tidak drop row
        return Date()
    }
    
    
    // buat isi"
    // MARK: - DTO list anggota & buku
    struct AnggotaListDTO: Decodable {
        let id_anggota: Int64
        let nama: String
    }
    
    struct BukuListDTO: Decodable {
        let id_buku: Int64
        let judul: String
        let tersedia: Bool
    }
    
    // MARK: - Fetch dropdown data
    func fetchAnggotaList() async throws -> [AnggotaListDTO] {
        try await client
            .from("anggota")
            .select("id_anggota, nama")
            .order("nama", ascending: true)
            .execute()
            .value
    }
    
    func fetchBukuTersediaList() async throws -> [BukuListDTO] {
        try await client
            .from("buku")
            .select("id_buku, judul, tersedia")
            .eq("tersedia", value: true)
            .order("judul", ascending: true)
            .execute()
            .value
    }
    
    // MARK: - Create transaksi + update stok buku
    func createTransaksi(
        idAnggota: Int64,
        idBuku: Int64,
        idPetugas: Int64,
        tanggalPinjam: Date,
        tanggalJatuhTempo: Date
    ) async throws {
        
        let tPinjam = dateOnlyFormatter.string(from: tanggalPinjam)
        let tTempo = dateOnlyFormatter.string(from: tanggalJatuhTempo)
        
        // 1) Insert transaksi (tanggal_pengembalian tidak dikirim -> null)
        try await client
            .from("data_peminjaman")
            .insert([
                "id_anggota": String(idAnggota),
                "id_buku": String(idBuku),
                "id_petugas": String(idPetugas),
                "tanggal_pinjam": tPinjam,
                "tanggal_jatuh_tempo": tTempo,
                "status": "dipinjam"
            ])
            .execute()
        
        // 2) Update buku jadi tidak tersedia
        try await client
            .from("buku")
            .update(["tersedia": false])
            .eq("id_buku", value: String(idBuku))
            .execute()
    }
    
}
