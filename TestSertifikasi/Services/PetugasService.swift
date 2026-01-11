//
//  PetugasService.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import Foundation
import Supabase

struct PetugasService {
    static func login(username: String, password: String) async throws -> LoginPetugasResponse {
        let res: LoginPetugasResponse = try await supabase
            .rpc("login_petugas", params: [
                "p_username": username,
                "p_password": password
            ])
            .execute()
            .value
        return res
    }
}
