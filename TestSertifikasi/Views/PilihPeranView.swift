//
//  PilihPeranView.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import SwiftUI

struct PilihPeranView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 8) {
                    Text("Masuk sebagai?")
                        .font(.title)
                        .bold()

                    Text("Pilih peran untuk melanjutkan")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 14) {

                    NavigationLink {
                        ContentView()
                    } label: {
                        KartuPeran(
                            judul: "Anggota",
                            deskripsi: "Lihat katalog & detail buku",
                            ikon: "person.fill"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        LoginPetugasView()
                    } label: {
                        KartuPeran(
                            judul: "Petugas",
                            deskripsi: "Login untuk kelola data",
                            ikon: "lock.fill"
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)

                Spacer()

                Text("Aplikasi Perpustakaan")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 12)
            }
            .padding()
        }
    }
}

private struct KartuPeran: View {
    let judul: String
    let deskripsi: String
    let ikon: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: ikon)
                .font(.system(size: 22, weight: .semibold))
                .frame(width: 44, height: 44)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(judul)
                    .font(.headline)

                Text(deskripsi)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.separator), lineWidth: 1)
        )

    }
}

#Preview {
    PilihPeranView()
}
