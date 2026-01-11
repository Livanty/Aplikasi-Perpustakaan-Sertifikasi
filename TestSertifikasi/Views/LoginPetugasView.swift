//
//  LoginPetugasView.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import SwiftUI
import Supabase

struct LoginPetugasView: View {
    @StateObject private var vm = PetugasAuthViewModel()
    
    var body: some View {
        Group {
            if let petugas = vm.petugas {
                DashboardPetugasView(
                    vm: DashboardPetugasViewModel(service: TransaksiService(client: supabase)),
                    idPetugas: Int64(petugas.id)
                )
            } else {
                loginCard
            }
        }
//        .navigationTitle("Login Petugas")
//        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
    
    private var loginCard: some View {
        ScrollView {
            VStack {
                VStack(spacing: 16) {
                    header
                    
                    field(
                        title: "Email",
                        systemImage: "person.fill",
                        content: AnyView(
                            TextField("Masukkan email", text: $vm.username)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        )
                    )
                    
                    field(
                        title: "Password",
                        systemImage: "lock.fill",
                        content: AnyView(
                            SecureField("Masukkan password", text: $vm.password)
                        )
                    )
                    
                    if let err = vm.errorMessage {
                        Text(err)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        Task { await vm.login() }
                    } label: {
                        HStack(spacing: 10) {
                            if vm.isLoading { ProgressView() }
                            Text(vm.isLoading ? "Memproses..." : "Login")
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(vm.isLoading || vm.username.isEmpty || vm.password.isEmpty)
                }
                .padding(18)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(.separator), lineWidth: 1)
                )
                .shadow(radius: 8, y: 4)
                .padding(.horizontal, 20)
                
            }
            .frame(maxWidth: .infinity, minHeight: 520, alignment: .center)
            .padding(.vertical, 24)
        }
    }
    
    private var header: some View {
        VStack(spacing: 6) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 34))
            Text("Login Petugas")
                .font(.title2).bold()
            Text("Masuk untuk mengelola data peminjaman.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 6)
    }
    
    private func field(title: String, systemImage: String, content: AnyView) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                
                content
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
        }
    }
}

#Preview {
    NavigationStack {
        LoginPetugasView()
    }
}

