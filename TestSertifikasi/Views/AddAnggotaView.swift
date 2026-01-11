//
//  AddAnggotaView.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import SwiftUI

struct AddAnggotaView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: AddAnggotaViewModel

    var body: some View {
        Form {
            Section("Data Anggota") {

                HStack {
                    Text("Nama")
                    Spacer()
                    TextField("Masukkan nama", text: $vm.nama)
                        .textInputAutocapitalization(.words)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Alamat")
                    Spacer()
                    TextField("Masukkan alamat", text: $vm.alamat)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("No. Telp")
                    Spacer()
                    TextField("08xxxxxxxxxx", text: $vm.noTelp)
                        .keyboardType(.phonePad)
                        .multilineTextAlignment(.trailing)
                }

                Picker("Jenis Kelamin", selection: $vm.jenisKelamin) {
                    ForEach(AddAnggotaViewModel.JenisKelamin.allCases) { jk in
                        Text(jk.rawValue).tag(jk)
                    }
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
                            Text("Simpan Anggota")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
                
                .disabled(vm.isLoading)
            }
        }
        .navigationTitle("Add Anggota")
        .navigationBarTitleDisplayMode(.inline)
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

#Preview {
    NavigationStack {
        AddAnggotaView(
            vm: AddAnggotaViewModel(
                service: AnggotaService(client: supabase)
            )
        )
    }
}

