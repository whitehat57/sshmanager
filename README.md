```markdown
# Manajer SSH Host untuk Termux

Sebuah script Bash untuk mengelola koneksi SSH dengan antarmuka CLI yang mudah digunakan di Termux.

## Fitur Utama

- ✅ Manajemen host SSH (tambah, edit, hapus, daftar)
- ✅ Koneksi cepat ke host yang tersimpan
- ✅ Mendukung opsi SSH khusus (seperti SetEnv)
- ✅ Antarmuka berwarna (colorful UI)
- ✅ Penyimpanan konfigurasi sederhana

## Cara Instalasi

1. Salin script ke perangkat Termux Anda:
   ```
   curl -o manajer-ssh.sh https://raw.githubusercontent.com/username/repo/main/manajer-ssh.sh
   ```

2. Berikan izin eksekusi:
   ```
   chmod +x manajer-ssh.sh
   ```

3. Jalankan script:
   ```
   ./manajer-ssh.sh
   ```

## Cara Penggunaan

### Menu Utama
```
1. Daftar SSH Host
2. Tambah Host Baru
3. Edit Host
4. Hapus Host
5. Hubungkan ke Host
6. Keluar
```

### 1. Menambahkan Host Baru
- Isikan informasi:
  - Nama/nickname host
  - Hostname/IP address
  - Port (default: 22)
  - Username
  - Opsi SSH tambahan (opsional)

Contoh untuk host dengan opsi khusus:
```
Nama: host_khusus
Hostname: contoh.com
Port: 2222
Username: admin
Opsi SSH: -o "SetEnv SECRET=kuncirahasia"
```

### 2. Menghubungkan ke Host
- Pilih nomor host dari daftar
- Script akan otomatis membangun perintah SSH dengan semua parameter yang diperlukan

### 3. Mengedit/Menghapus Host
- Pilih host dari daftar
- Edit informasi atau konfirmasi penghapusan

## Lokasi Penyimpanan
Script menyimpan semua host SSH di file:
```
~/.manajer_ssh_host
```

Format penyimpanan:
```
nama_host|hostname|port|username|opsi_ssh
```

## Contoh Penggunaan

### Menambahkan host dengan opsi khusus:
1. Pilih menu 2 (Tambah Host Baru)
2. Isikan:
   ```
   Nama: server_prod
   Hostname: 192.168.1.100
   Port: 22
   Username: deploy
   Opsi SSH: -o "StrictHostKeyChecking=no" -i ~/.ssh/key_khusus
   ```

### Menghubungkan ke host:
1. Pilih menu 5 (Hubungkan ke Host)
2. Pilih nomor host dari daftar
3. Koneksi SSH akan langsung terbentuk

## Dukungan Opsi SSH
Script mendukung berbagai opsi SSH seperti:
- `-o "Option=value"`
- `-i /path/to/key`
- `-p port`
- `-v` (verbose mode)
- Dan semua opsi SSH standar lainnya

## Troubleshooting

**Masalah**: Koneksi gagal dengan pesan error
- Solusi: Periksa opsi SSH yang digunakan dan pastikan formatnya benar

**Masalah**: File konfigurasi tidak terbaca
- Solusi: Pastikan file `.manajer_ssh_host` ada di direktori home

**Masalah**: Tampilan warna tidak muncul
- Solusi: Pastikan terminal Termux mendukung kode warna ANSI

## Kontribusi
Pull request dipersilakan. Untuk perubahan besar, buka issue terlebih dahulu untuk didiskusikan.

## Lisensi
[MIT](https://choosealicense.com/licenses/mit/)
``` 

Dokumentasi ini mencakup:
1. Informasi instalasi
2. Petunjuk penggunaan lengkap
3. Contoh-contoh praktis
4. Penyelesaian masalah
5. Struktur file konfigurasi
6. Informasi lisensi

Anda bisa menyesuaikan bagian seperti URL script GitHub sesuai dengan repositori Anda.
