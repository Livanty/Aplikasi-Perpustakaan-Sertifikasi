//
//  Petugas.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import Foundation

struct Petugas: Codable, Identifiable {
    let id: Int
    let username: String

    enum CodingKeys: String, CodingKey {
        case id = "id_petugas"
        case username
    }
}
