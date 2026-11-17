# Smart Helpdesk Classifier — Tkinter + SQLite

Aplikasi ini adalah pengembangan dari kode klasifikasi pertanyaan menjadi aplikasi dengan:
- Model TF-IDF + Logistic Regression yang **dilatih dari tabel `data_latih` SQLite**.
- Pencarian FAQ berbasis kemiripan teks pada tabel `faq` untuk memilih **jawaban panjang**.
- Tabel `kategori` untuk menyimpan panduan umum jika pertanyaan belum cocok dengan FAQ tertentu.
- Filter kata kunci untuk mengurangi jawaban yang keliru pada pertanyaan di luar layanan.
- GUI Tkinter dengan area jawaban yang bisa digulir, tombol salin, muat ulang model, serta tab penampil FAQ.

**Penting:** Ini bukan model AI generatif atau sumber informasi kampus secara langsung. Semua jawaban adalah *contoh panduan umum*, bukan prosedur atau jadwal resmi kampus. Model belum diuji akurasinya pada dataset evaluasi independen. Angka probabilitas model tidak sama dengan akurasi jawaban.

## Isi folder

| Berkas | Fungsi |
|---|---|
| `smart_helpdesk.py` | Aplikasi GUI utama. Semua data model dan jawaban dibaca dari SQLite. |
| `helpdesk.db` | Database SQLite siap dibuka menggunakan DB Browser for SQLite. |
| `inisialisasi_database.py` | Skrip pembuatan database dan 18 data awal (bisa dijalankan ulang tanpa menghapus edit yang sudah ada). |
| `helpdesk_dump.sql` | Alternatif membuat database melalui **Execute SQL** pada DB Browser for SQLite. |
| `README.md` | Petunjuk penggunaan. |

## Langkah 1 — Instalasi

Gunakan Python 3.10 atau yang lebih baru pada Windows/macOS/Linux. Python Windows umumnya menyertakan `tkinter` dan `sqlite3`.

Buka Terminal / Command Prompt di folder ini, lalu jalankan:

```bash
python -m pip install scikit-learn
```

Tidak diperlukan instalasi driver database tambahan: SQLite diakses melalui modul standar Python `sqlite3`. **DB Browser for SQLite** adalah aplikasi desktop untuk melihat/mengedit berkas database, bukan server database.

Jika Linux menampilkan masalah modul `tkinter`, pasang paket `python3-tk` melalui pengelola paket sistem.

## Langkah 2 — Jalankan GUI

Pastikan `smart_helpdesk.py` dan `helpdesk.db` berada dalam folder yang sama.

```bash
python smart_helpdesk.py
```

Ketik salah satu contoh berikut, lalu klik **Proses Pertanyaan** atau tekan **Ctrl+Enter**:

- Bagaimana cara mengisi KRS?
- Saya membutuhkan surat aktif kuliah.
- Saya tidak bisa login ke LMS.
- Kapan pengisian KRS dibuka?
- Cara legalisir transkrip?

Hasil menampilkan kategori, skor probabilitas kelas model, kemiripan FAQ, topik, dan jawaban langkah demi langkah. Pilih tab **Lihat Basis Pengetahuan** untuk melihat daftar FAQ yang dibaca dari database.

## Langkah 3 — Buka dan edit database pada DB Browser for SQLite

1. Buka aplikasi **DB Browser for SQLite**.
2. Pilih **Open Database** / **Buka Database**.
3. Pilih berkas **`helpdesk.db`** dari folder proyek.
4. Pilih tab **Browse Data**.
5. Gunakan daftar **Table** untuk melihat `data_latih`, `faq`, atau `kategori`.
6. Jika ingin mengubah jawaban, pilih tabel `faq`, temukan barisnya, lalu edit kolom **`jawaban`**. Anda juga dapat mengedit `judul` dan `kata_kunci`.
7. Klik **Write Changes** / **Simpan Perubahan** pada DB Browser. Jika ada transaksi tertunda, selesaikan sebelum kembali ke aplikasi.
8. Pada GUI Smart Helpdesk, klik **Muat Ulang Database**. Model akan dilatih ulang memakai isi terbaru tabel `data_latih` dan pencari FAQ akan memuat jawaban yang baru.

Saat menyimpan perubahan, jika muncul pesan database terkunci, tutup jendela editor SQL atau transaksi lain yang masih terbuka lalu coba lagi. Aplikasi helpdesk membaca database, bukan menulis ke dalamnya.

## Menambah contoh pertanyaan dan jawaban baru

**A. Tambahkan jawaban baru pada tabel `faq`**. Kolomnya:

- `id` — kosongkan agar dibuat otomatis.
- `pertanyaan` — satu contoh pertanyaan pengguna.
- `kategori` — `Akademik`, `Administrasi`, atau `Teknis` (harus cocok dengan tabel `kategori`).
- `judul` — judul/topik singkat.
- `jawaban` — tulis jawaban panjang; dapat menggunakan paragraf, langkah bernomor, dan catatan.
- `kata_kunci` — frasa pengenal yang dipisahkan dengan garis tegak (`|`), misalnya `password lms|lms|akun lms`. **Kolom ini penting** agar topik dapat terdeteksi.

**B. Tambahkan data pelatihan pada tabel `data_latih`**, minimal beberapa variasi kalimat untuk topik baru. Kolom:

- `id` — kosongkan.
- `pertanyaan` — contoh kalimat pertanyaan yang bervariasi.
- `kategori` — nama kategori yang ada di tabel `kategori`.

**C. Jika membuat kategori baru**, tambahkan lebih dahulu satu baris pada tabel `kategori` (`nama`, `deskripsi`, `panduan_umum`), kemudian buat data pelatihan dan FAQ untuk kategori tersebut.

**D. Klik `Write Changes` di DB Browser, lalu `Muat Ulang Database` di GUI.**

Catatan: menambah satu contoh FAQ tidak otomatis memperbaiki seluruh kemampuan model. Tambahkan variasi kalimat yang mewakili maksud yang sama, evaluasi pada pertanyaan nyata yang berbeda, dan sesuaikan kata kunci. Hindari memasukkan tanggal/jam/tautan layanan yang belum diverifikasi.

## Jika berkas `helpdesk.db` hilang

Jalankan:

```bash
python inisialisasi_database.py
```

Skrip tersebut membuat database awal, tabel kategori, 18 data pelatihan dari kode asli, dan 18 FAQ panjang. Jika database sudah ada, skrip hanya menambahkan data awal yang belum ada serta melengkapi kata kunci yang kosong; **tidak menghapus atau menimpa jawaban yang sudah diedit**.

Alternatif tanpa menjalankan skrip Python: buat database kosong di DB Browser for SQLite, lalu pada tab **Execute SQL** buka file `helpdesk_dump.sql`, jalankan seluruh SQL, dan simpan perubahan dengan **Write Changes**.

## Struktur tabel (ringkas)

```sql
CREATE TABLE kategori (
    nama TEXT PRIMARY KEY,
    deskripsi TEXT NOT NULL,
    panduan_umum TEXT NOT NULL
);

CREATE TABLE data_latih (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pertanyaan TEXT NOT NULL UNIQUE,
    kategori TEXT NOT NULL,
    FOREIGN KEY (kategori) REFERENCES kategori(nama)
);

CREATE TABLE faq (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pertanyaan TEXT NOT NULL UNIQUE,
    kategori TEXT NOT NULL,
    judul TEXT NOT NULL,
    jawaban TEXT NOT NULL,
    kata_kunci TEXT NOT NULL DEFAULT '',
    FOREIGN KEY (kategori) REFERENCES kategori(nama)
);
```

### Saran pengembangan berikutnya

Untuk penggunaan resmi sebaiknya menambah validasi dataset, pengujian yang terpisah, formulir administrasi data dengan kontrol akses, riwayat pertanyaan, serta sumber data akademik resmi yang diperbarui dan diaudit. Untuk jawaban baru yang benar-benar disusun dinamis diperlukan komponen generatif/LLM atau mesin aturan tambahan; sistem saat ini memilih jawaban yang telah disediakan di SQLite.
"# smarthelpdesk" 
"# smarthelpdesk" 
"# smarthelpdesk" 
"# smarthelpdesk" 
"# smarthelpdesk" 
"# smarthelpdesk" 
"# smarthelpdesk" 
"# smarthelpdesk" 
"# smarthelpdesk" 
"# smarthelpdesk" 
"# smarthelpdesk" 
