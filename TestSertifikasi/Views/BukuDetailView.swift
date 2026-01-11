//
//  BukuDetailView.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import SwiftUI

struct BukuDetailView: View {
    let buku: Buku

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                AsyncImage(url: URL(string: buku.cover_url)) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 18)
                            .fill(.gray.opacity(0.2))
                            .overlay(ProgressView())
                    case .success(let image):
                        image
                             .resizable()
                             .scaledToFill()
                    case .failure:
                        RoundedRectangle(cornerRadius: 18)
                            .fill(.gray.opacity(0.2))
                            .overlay(
                                Image(systemName: "book.closed")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                //.frame(height: 320)
                .clipped()
                .cornerRadius(2)

                HStack(alignment: .top, spacing: 12) {
                    Text(buku.judul)
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(buku.tersedia ? "TERSEDIA" : "DIPINJAM")
                        .font(.caption2)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(buku.tersedia ? Color.green : Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }

                VStack(spacing: 12) {
                    InfoRow(icon: "person.fill", title: "Penulis", value: buku.penulis)
                    InfoRow(icon: "building.2.fill", title: "Penerbit", value: buku.penerbit)
                    InfoRow(icon: "calendar", title: "Tahun Terbit", value: "\(buku.tahun_terbit)")
                    InfoRow(icon: "barcode", title: "ISBN", value: buku.isbn)
                }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Detail Buku")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

private struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    BukuDetailView(
        buku: Buku(
            id: 1,
            isbn: "9786020324788", judul: "Laskar Pelangi",
            penulis: "Andrea Hirata",
            penerbit: "Bentang Pustaka",
            tahun_terbit: 2005,
            tersedia: true,
            cover_url: "https://upload.wikimedia.org/wikipedia/id/thumb/8/8e/Laskar_pelangi_sampul.jpg/250px-Laskar_pelangi_sampul.jpg"
        )
    )
}
