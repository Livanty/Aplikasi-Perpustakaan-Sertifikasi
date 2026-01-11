//
//  AddTransaksiView.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import SwiftUI

struct AddTransaksiView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: AddTransaksiViewModel

    var body: some View {
        Form {
            Section("Anggota") {
                Picker("Pilih Anggota", selection: Binding(
                    get: { vm.selectedAnggotaId ?? 0 },
                    set: { vm.selectedAnggotaId = $0 }
                )) {
                    ForEach(vm.anggota, id: \.id_anggota) { a in
                        Text(a.nama).tag(a.id_anggota)
                    }
                }
            }

            Section("Buku") {
                if vm.buku.isEmpty {
                    Text("Tidak ada buku tersedia.")
                        .foregroundStyle(.secondary)
                } else {
                    Picker("Pilih Buku", selection: Binding(
                        get: { vm.selectedBukuId ?? 0 },
                        set: { vm.selectedBukuId = $0 }
                    )) {
                        ForEach(vm.buku, id: \.id_buku) { b in
                            Text(b.judul).tag(b.id_buku)
                        }
                    }
                }
            }

            Section("Tanggal") {
                DatePicker("Tanggal Pinjam", selection: $vm.tanggalPinjam, displayedComponents: .date)
                HStack {
                    Text("Jatuh Tempo")
                    Spacer()
                    Text(vm.tanggalJatuhTempo, style: .date)
                        .foregroundStyle(.secondary)
                }

            }

            Section {
                Button {
                    Task { await vm.save() }
                } label: {
                    HStack {
                        Spacer()
                        if vm.isLoading {
                            ProgressView()
                        } else {
                            Text("Simpan Transaksi")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
                
                .disabled(vm.isLoading || vm.buku.isEmpty)
            }
        }
        .background(Color(.systemGroupedBackground))

        .navigationTitle("Add Transaksi")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.loadFormData() }
        .alert("Info", isPresented: $vm.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(vm.errorMessage ?? "Terjadi kesalahan.")
        }
        .onChange(of: vm.didSave) { _, saved in
            if saved { dismiss() }
        }
    }
}
