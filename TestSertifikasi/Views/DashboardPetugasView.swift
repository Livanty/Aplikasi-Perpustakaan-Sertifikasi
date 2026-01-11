//
//  DashboardPetugasView.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import SwiftUI

struct DashboardPetugasView: View {
    @StateObject var vm: DashboardPetugasViewModel
    let idPetugas: Int64
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                
                HStack(spacing: 10) {
                    NavigationLink {
                        AddAnggotaView(
                            vm: AddAnggotaViewModel(
                                service: AnggotaService(client: supabase)
                            )
                        )
                    } label: {
                        Label("Add Anggota", systemImage: "person.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    
                    
                    NavigationLink {
                        AddTransaksiView(
                            vm: AddTransaksiViewModel(
                                service: TransaksiService(client: supabase),
                                idPetugas: idPetugas
                            )
                        )
                    } label: {
                        Label("Add Transaksi", systemImage: "plus.rectangle.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                }
                
                if vm.isLoading {
                    ProgressView().padding(.top, 20)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.list) { item in
                                TransaksiRow(item: item) {
                                    Task { await vm.tapCheck(item) }
                                }
                            }
                        }
                        .padding(.top, 4)
                    }
                }
            }
            .padding()
            .navigationTitle("Dashboard Petugas")
            .task { await vm.load() }
            .onAppear { Task { await vm.load() }
                
            }
            .alert("Info", isPresented: Binding( //error handling
                get: { vm.errorMessage != nil },
                set: { _ in vm.errorMessage = nil }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(vm.errorMessage ?? "")
                
            }
            
        }
    }
}
