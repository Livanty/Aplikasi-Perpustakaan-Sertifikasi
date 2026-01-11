# Aplikasi-Perpustakaan-Sertifikasi 

## SDLC (Waterfall)

Pengembangan aplikasi ini mengikuti pendekatan **SDLC model Waterfall**, yaitu proses pembangunan dilakukan secara **bertahap dan berurutan** mulai dari analisis kebutuhan, perancangan sistem, implementasi, pengujian, hingga aplikasi siap digunakan. Model ini dipilih karena kebutuhan fitur sudah jelas sejak awal sehingga pengembangan dapat dilakukan secara terstruktur.

## Tujuan 
Pengembangan Aplikasi ini dikembangkan sebagai Tugas Praktik Demonstrasi untuk memenuhi kompetensi pada skema sertifikasi Programmer, khususnya dalam penerapan pemrograman berorientasi objek, akses basis data, dan arsitektur aplikasi. 

## Fitur Utama 
- Login untuk petugas perpustakaan
- Lihat historis data peminjaman buku
- Pencatatan data anggota
- Pencatatan transaksi peminjaman buku (Jatuh tempo Otomatis 7 hari)
- Tampilan daftar dan detail buku

## Konsep Pemrograman - Pemrograman berorientasi objek (OOP)
- Pemisahan tanggung jawab dengan MVVM
- Penggunaan service layer untuk akses basis data
- Penanganan error dan validasi data

## Teknologi 
- Bahasa Pemrograman: Swift
- Framework UI: SwiftUI
- Arsitektur: MVVM
- Basis Data: Supabase (PostgreSQL)
- IDE: Xcode
- Version Control: Git & GitHub

## Struktur Proyek

App/
- Entry point aplikasi (TestSertifikasiApp)

Models/
- Buku
- Petugas
- Transaksi
- StatusPeminjaman
- LoginPetugasResponse

Services/
- AnggotaService
- BukuService
- PetugasService
- TransaksiService
- SupabaseClient

ViewModels/
- AddAnggotaViewModel
- AddTransaksiViewModel
- BukuViewModel
- DashboardPetugasViewModel
- PetugasAuthViewModel

Views/
- LoginPetugasView
- DashboardPetugasView
- BukuCard
- BukuDetailView
- AddAnggotaView
- AddTransaksiView
- TransaksiRow

## ERD 
<img width="698" height="650" alt="image" src="https://github.com/user-attachments/assets/dba4aedf-469d-4c71-96ec-a83baf60b6ce" /> 

Anggota dan Buku memiliki relasi many-to-many, sehingga digunakan tabel Data_Peminjaman sebagai tabel penghubung. Data_Peminjaman memiliki relasi one-to-many dengan Petugas, karena satu petugas dapat menangani banyak transaksi peminjaman.

## Object-Oriented Programming (OOP)

Aplikasi ini menerapkan konsep **Object-Oriented Programming (OOP)** untuk membangun kode yang terstruktur dan modular.

- **Class & Object**  
  Setiap fitur utama direpresentasikan dalam bentuk class seperti `TransaksiService`, `AnggotaService`, dan `ViewModel`.

- **Encapsulation**  
  Detail implementasi disembunyikan di dalam class, misalnya properti database dibuat `private`.

- **Separation of Concerns**  
  Aplikasi dipisahkan menjadi View (UI), ViewModel (state & logika), Service (logika bisnis & database), dan Model/DTO (data).

- **Abstraction**  
  View tidak berinteraksi langsung dengan database, melainkan melalui ViewModel.

- **Dependency Injection**  
  Service dikirim ke ViewModel melalui initializer untuk mengurangi ketergantungan langsung.

- **Reactive State**  
  State dikelola menggunakan `@Published` dan `@StateObject` sehingga UI otomatis diperbarui saat data berubah.

Pendekatan ini membuat aplikasi lebih mudah dipahami, dirawat, dan dikembangkan.

