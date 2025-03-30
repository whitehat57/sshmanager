#!/bin/bash

# Lokasi file konfigurasi
FILE_KONFIG="$HOME/.manajer_ssh_host"

# Warna
MERAH='\033[0;31m'
HIJAU='\033[0;32m'
KUNING='\033[1;33m'
BIRU='\033[0;34m'
NC='\033[0m' # No Color

# Cek jika file konfig tidak ada, buat baru
if [ ! -f "$FILE_KONFIG" ]; then
    touch "$FILE_KONFIG"
fi

# Fungsi untuk menampilkan menu
tampilkan_menu() {
    clear
    echo -e "${KUNING}Manajer SSH Host${NC}"
    echo -e "${HIJAU}1. Daftar SSH Host${NC}"
    echo -e "${HIJAU}2. Tambah Host Baru${NC}"
    echo -e "${HIJAU}3. Edit Host${NC}"
    echo -e "${HIJAU}4. Hapus Host${NC}"
    echo -e "${HIJAU}5. Hubungkan ke Host${NC}"
    echo -e "${MERAH}6. Keluar${NC}"
    echo -n "Pilih opsi [1-6]: "
}

# Fungsi untuk menampilkan daftar host
daftar_host() {
    clear
    echo -e "${KUNING}Daftar Host SSH Tersimpan:${NC}"
    echo -e "${BIRU}------------------------------------------------${NC}"
    
    if [ ! -s "$FILE_KONFIG" ]; then
        echo -e "${MERAH}Tidak ada host SSH yang ditemukan.${NC}"
    else
        awk -F'|' '{printf "%3d | %-20s | %-15s | %-5s | %-20s\n", NR, $1, $2, $3, $4}' "$FILE_KONFIG"
    fi
    
    echo -e "${BIRU}------------------------------------------------${NC}"
    read -n 1 -s -r -p "Tekan sembarang tombol untuk melanjutkan..."
}

# Fungsi untuk menambah host baru
tambah_host() {
    clear
    echo -e "${KUNING}Tambah Host SSH Baru${NC}"
    echo -e "${BIRU}------------------------------------------------${NC}"
    
    read -p "Masukkan nama/nickname host: " nama
    read -p "Masukkan hostname/IP: " hostname
    read -p "Masukkan port [22]: " port
    port=${port:-22}
    read -p "Masukkan username: " username
    read -p "Masukkan opsi SSH tambahan (opsional): " opsi
    
    # Simpan ke file konfig
    echo "$nama|$hostname|$port|$username|$opsi" >> "$FILE_KONFIG"
    
    echo -e "${HIJAU}Host '$nama' berhasil ditambahkan!${NC}"
    sleep 1
}

# Fungsi untuk mengedit host
edit_host() {
    clear
    echo -e "${KUNING}Edit Host SSH${NC}"
    echo -e "${BIRU}------------------------------------------------${NC}"
    
    if [ ! -s "$FILE_KONFIG" ]; then
        echo -e "${MERAH}Tidak ada host SSH untuk diedit.${NC}"
        sleep 1
        return
    fi
    
    daftar_host
    echo -e "${BIRU}------------------------------------------------${NC}"
    read -p "Masukkan nomor host yang akan diedit: " nomor_host
    
    total_host=$(wc -l < "$FILE_KONFIG")
    if [ "$nomor_host" -lt 1 ] || [ "$nomor_host" -gt "$total_host" ]; then
        echo -e "${MERAH}Pilihan tidak valid.${NC}"
        sleep 1
        return
    fi
    
    # Ambil host yang dipilih
    baris_host=$(sed -n "${nomor_host}p" "$FILE_KONFIG")
    IFS='|' read -ra data_host <<< "$baris_host"
    
    echo -e "\nMengedit host: ${KUNING}${data_host[0]}${NC}"
    read -p "Masukkan nama baru [${data_host[0]}]: " nama
    read -p "Masukkan hostname/IP baru [${data_host[1]}]: " hostname
    read -p "Masukkan port baru [${data_host[2]}]: " port
    read -p "Masukkan username baru [${data_host[3]}]: " username
    read -p "Masukkan opsi SSH baru [${data_host[4]}]: " opsi
    
    # Gunakan nilai lama jika baru kosong
    nama=${nama:-${data_host[0]}}
    hostname=${hostname:-${data_host[1]}}
    port=${port:-${data_host[2]}}
    username=${username:-${data_host[3]}}
    opsi=${opsi:-${data_host[4]}}
    
    # Update file konfig
    sed -i "${nomor_host}s/.*/$nama|$hostname|$port|$username|$opsi/" "$FILE_KONFIG"
    
    echo -e "${HIJAU}Host berhasil diperbarui!${NC}"
    sleep 1
}

# Fungsi untuk menghapus host
hapus_host() {
    clear
    echo -e "${KUNING}Hapus Host SSH${NC}"
    echo -e "${BIRU}------------------------------------------------${NC}"
    
    if [ ! -s "$FILE_KONFIG" ]; then
        echo -e "${MERAH}Tidak ada host SSH untuk dihapus.${NC}"
        sleep 1
        return
    fi
    
    daftar_host
    echo -e "${BIRU}------------------------------------------------${NC}"
    read -p "Masukkan nomor host yang akan dihapus: " nomor_host
    
    total_host=$(wc -l < "$FILE_KONFIG")
    if [ "$nomor_host" -lt 1 ] || [ "$nomor_host" -gt "$total_host" ]; then
        echo -e "${MERAH}Pilihan tidak valid.${NC}"
        sleep 1
        return
    fi
    
    # Ambil nama host untuk konfirmasi
    nama_host=$(sed -n "${nomor_host}p" "$FILE_KONFIG" | cut -d'|' -f1)
    
    read -p "Apakah Anda yakin ingin menghapus '$nama_host'? [y/N]: " konfirmasi
    if [[ "$konfirmasi" =~ ^[Yy]$ ]]; then
        sed -i "${nomor_host}d" "$FILE_KONFIG"
        echo -e "${HIJAU}Host '$nama_host' berhasil dihapus!${NC}"
    else
        echo -e "${KUNING}Penghapusan dibatalkan.${NC}"
    fi
    
    sleep 1
}

# Fungsi untuk menghubungkan ke host
hubungkan_host() {
    clear
    echo -e "${KUNING}Hubungkan ke Host SSH${NC}"
    echo -e "${BIRU}------------------------------------------------${NC}"
    
    if [ ! -s "$FILE_KONFIG" ]; then
        echo -e "${MERAH}Tidak ada host SSH untuk dihubungkan.${NC}"
        sleep 1
        return
    fi
    
    daftar_host
    echo -e "${BIRU}------------------------------------------------${NC}"
    read -p "Masukkan nomor host yang akan dihubungkan: " nomor_host
    
    total_host=$(wc -l < "$FILE_KONFIG")
    if [ "$nomor_host" -lt 1 ] || [ "$nomor_host" -gt "$total_host" ]; then
        echo -e "${MERAH}Pilihan tidak valid.${NC}"
        sleep 1
        return
    fi
    
    # Ambil host yang dipilih
    baris_host=$(sed -n "${nomor_host}p" "$FILE_KONFIG")
    IFS='|' read -ra data_host <<< "$baris_host"
    
    nama=${data_host[0]}
    hostname=${data_host[1]}
    port=${data_host[2]}
    username=${data_host[3]}
    opsi=${data_host[4]}
    
    echo -e "\nMenghubungkan ke ${KUNING}$nama${NC} ($username@$hostname:$port)..."
    echo -e "${BIRU}Tekan Ctrl+D atau ketik 'exit' untuk memutuskan.${NC}\n"
    
    # Bangun perintah SSH
    perintah_ssh="ssh"
    [ -n "$port" ] && perintah_ssh+=" -p $port"
    [ -n "$opsi" ] && perintah_ssh+=" $opsi"
    perintah_ssh+=" $username@$hostname"
    
    # Jalankan perintah SSH
    eval "$perintah_ssh"
    
    read -n 1 -s -r -p "Tekan sembarang tombol untuk melanjutkan..."
}

# Program utama
while true; do
    tampilkan_menu
    read pilihan
    
    case $pilihan in
        1) daftar_host ;;
        2) tambah_host ;;
        3) edit_host ;;
        4) hapus_host ;;
        5) hubungkan_host ;;
        6) echo -e "\n${KUNING}Selamat tinggal!${NC}"; exit 0 ;;
        *) echo -e "\n${MERAH}Opsi tidak valid!${NC}"; sleep 1 ;;
    esac
done
