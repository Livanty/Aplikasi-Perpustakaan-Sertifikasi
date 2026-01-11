//
//  Transaksi.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 11/01/26.
//


import Foundation

struct Transaksi: Identifiable, Equatable {
    let id: Int64               // id_data
    let idAnggota: Int64
    let idBuku: Int64
    let idPetugas: Int64

    let namaAnggota: String
    let alamatAnggota: String
    let noTelpAnggota: String
    let judulBuku: String

    let tanggalPinjam: Date
    let tanggalJatuhTempo: Date
    let tanggalPengembalian: Date?

    let status: StatusPeminjaman
}
