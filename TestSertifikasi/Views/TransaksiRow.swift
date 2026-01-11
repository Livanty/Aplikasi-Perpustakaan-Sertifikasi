//
//  TransaksiRow.swift
//  TestSertifikasi
//
//  Created by Livanty Efatania Dendy on 10/01/26.
//


import SwiftUI

struct TransaksiRow: View {
    let item: Transaksi
    let onCheck: () -> Void
    
    private let df: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "id_ID")
        f.dateFormat = "dd MMM yyyy"
        return f
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.namaAnggota)
                        .font(.headline)
                    
                    Text(item.judulBuku)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(item.alamatAnggota)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    
                    Text(item.noTelpAnggota)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                badge
            }
            
            Text("\(df.string(from: item.tanggalPinjam)) → \(df.string(from: item.tanggalJatuhTempo))")
                .font(.subheadline)
            
            HStack {
                Text("Pengembalian:")
                    .foregroundStyle(.secondary)
                Text(item.tanggalPengembalian.map { df.string(from: $0) } ?? "-")
                
                Spacer()
                
                if item.status == .dipinjam {
                    Button(action: onCheck) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title)
                    }
                    .buttonStyle(.plain)
                }
            }
            .font(.subheadline)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.secondary.opacity(0.35), lineWidth: 1)
        )
    }
    
    private var badge: some View {
        let isDipinjam = (item.status == .dipinjam)
        return Text(isDipinjam ? "Dipinjam" : "Selesai")
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(isDipinjam ? Color.orange.opacity(0.25) : Color.green.opacity(0.25)))
            .foregroundStyle(isDipinjam ? .orange : .green)
    }
}
