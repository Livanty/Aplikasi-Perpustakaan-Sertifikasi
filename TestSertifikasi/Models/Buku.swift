//
//  Buku.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import Foundation

struct Buku: Identifiable, Decodable {
    let id: Int
    let isbn: String
    let judul: String
    let penulis: String
    let penerbit: String
    let tahun_terbit: Int
    let tersedia: Bool
    let cover_url: String

    enum CodingKeys: String, CodingKey {
        case id = "id_buku"
        case isbn
        case judul
        case penulis
        case penerbit
        case tahun_terbit
        case tersedia
        case cover_url
    }
}
