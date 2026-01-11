//
//  BukuCard.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import SwiftUI

struct BukuCard: View {
    let buku: Buku
    
    var body: some View { NavigationLink {
        BukuDetailView(buku: buku) 
    } label: {
        VStack(alignment: .leading, spacing: 5) {
            
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: buku.cover_url)) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.gray.opacity(0.2))
                            .overlay(ProgressView())
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.gray.opacity(0.2))
                            .overlay(Image(systemName: "book.closed").font(.largeTitle))
                    @unknown default:
                        EmptyView()
                    }
                }
                //.frame(height: 170)
                .clipped()
                .cornerRadius(14)
                
                Text(buku.tersedia ? "TERSEDIA" : "DIPINJAM")
                    .font(.caption2).bold()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(buku.tersedia ? .green : .red)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(10)
            }
            Spacer(minLength: 5)
            Text(buku.judul.uppercased())
                .font(.headline)
                .lineLimit(2)
            
            HStack(spacing: 8) {
                Image(systemName: "person.fill")
                    .foregroundColor(.secondary)
                Text(buku.penulis)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            HStack(spacing: 8) {
                Image(systemName: "building.2.fill")
                    .foregroundColor(.secondary)
                Text(buku.penerbit)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }.buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
