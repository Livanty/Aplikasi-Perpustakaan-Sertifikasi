//
//  LoginPetugasResponse.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import Foundation

struct LoginPetugasResponse: Decodable {
    let ok: Bool
    let message: String?
    let idPetugas: Int?
    let username: String?

    enum CodingKeys: String, CodingKey {
        case ok, message
        case idPetugas = "id_petugas"
        case username
    }
}
