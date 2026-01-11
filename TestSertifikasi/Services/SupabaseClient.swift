//
//  SupabaseClient.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//

import Foundation
import Supabase

let supabase: SupabaseClient = {
    guard let url = URL(string: "https://dbrqifsnygzqpmqcitxp.supabase.co") else {
        fatalError("Supabase URL invalid")
    }
    return SupabaseClient(supabaseURL: url, supabaseKey: "sb_publishable_v7CXU1puIPlSWCoJrcw0NQ_86M-joX3")
}()
