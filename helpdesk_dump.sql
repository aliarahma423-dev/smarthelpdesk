-- Smart Helpdesk SQLite | berkas SQL untuk DB Browser for SQLite
-- Jalankan pada DATABASE BARU yang kosong.
PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;
CREATE TABLE data_latih (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                pertanyaan TEXT NOT NULL UNIQUE,
                kategori TEXT NOT NULL,
                FOREIGN KEY (kategori) REFERENCES kategori(nama)
            );
INSERT INTO "data_latih" VALUES(1,'Bagaimana cara mengisi KRS?','Akademik');
INSERT INTO "data_latih" VALUES(2,'Kapan jadwal UTS semester ini?','Akademik');
INSERT INTO "data_latih" VALUES(3,'Bagaimana melihat jadwal kuliah?','Akademik');
INSERT INTO "data_latih" VALUES(4,'Saya ingin mengetahui nilai mata kuliah.','Akademik');
INSERT INTO "data_latih" VALUES(5,'Bagaimana prosedur perubahan KRS?','Akademik');
INSERT INTO "data_latih" VALUES(6,'Kapan pengisian KRS dibuka?','Akademik');
INSERT INTO "data_latih" VALUES(7,'Saya membutuhkan surat aktif kuliah.','Administrasi');
INSERT INTO "data_latih" VALUES(8,'Bagaimana cara mengurus surat mahasiswa?','Administrasi');
INSERT INTO "data_latih" VALUES(9,'Di mana mengajukan surat keterangan?','Administrasi');
INSERT INTO "data_latih" VALUES(10,'Bagaimana prosedur legalisir dokumen?','Administrasi');
INSERT INTO "data_latih" VALUES(11,'Saya ingin mengurus transkrip.','Administrasi');
INSERT INTO "data_latih" VALUES(12,'Bagaimana prosedur administrasi akademik?','Administrasi');
INSERT INTO "data_latih" VALUES(13,'WiFi kampus tidak bisa terhubung.','Teknis');
INSERT INTO "data_latih" VALUES(14,'Saya tidak bisa login ke LMS.','Teknis');
INSERT INTO "data_latih" VALUES(15,'Komputer laboratorium tidak menyala.','Teknis');
INSERT INTO "data_latih" VALUES(16,'Website kampus menampilkan error.','Teknis');
INSERT INTO "data_latih" VALUES(17,'Aplikasi kampus tidak bisa dibuka.','Teknis');
INSERT INTO "data_latih" VALUES(18,'Saya mengalami masalah pada jaringan.','Teknis');
CREATE TABLE faq (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                pertanyaan TEXT NOT NULL UNIQUE,
                kategori TEXT NOT NULL,
                judul TEXT NOT NULL,
                jawaban TEXT NOT NULL,
                kata_kunci TEXT NOT NULL DEFAULT '',
                FOREIGN KEY (kategori) REFERENCES kategori(nama)
            );
INSERT INTO "faq" VALUES(1,'Bagaimana cara mengisi KRS?','Akademik','Panduan pengisian KRS','Kartu Rencana Studi (KRS) digunakan untuk merencanakan mata kuliah yang akan diambil pada semester berjalan.

Langkah umum pengisian KRS:
1. Pastikan status registrasi atau administrasi semester sudah memenuhi ketentuan kampus.
2. Masuk ke sistem informasi akademik dengan akun resmi mahasiswa.
3. Buka menu KRS dan pilih semester akademik yang sedang aktif.
4. Pilih mata kuliah yang ditawarkan sesuai kurikulum, prasyarat, batas SKS, dan jadwal yang tidak berbenturan.
5. Periksa kembali mata kuliah yang dipilih, lalu simpan atau ajukan KRS sesuai alur sistem.
6. Pantau persetujuan dosen pembimbing akademik apabila diwajibkan dan simpan bukti pengisian.

Catatan: nama menu, batas SKS, persyaratan, dan jadwal resmi berbeda menurut kebijakan perguruan tinggi. Konfirmasikan melalui sistem akademik atau petugas program studi.','krs|kartu rencana studi|rencana studi');
INSERT INTO "faq" VALUES(2,'Kapan jadwal UTS semester ini?','Akademik','Informasi jadwal UTS','Jadwal Ujian Tengah Semester (UTS) umumnya diumumkan melalui kalender akademik, pengumuman program studi, atau sistem pembelajaran kampus.

Cara memeriksa jadwal:
1. Buka kalender akademik untuk tahun dan semester yang sedang berjalan.
2. Periksa pengumuman resmi program studi atau fakultas terkait rentang waktu UTS.
3. Lihat jadwal ujian setiap mata kuliah karena tanggal, jam, dan ruang dapat berbeda.
4. Pastikan apakah ujian dilakukan secara tatap muka, daring, atau melalui penugasan.
5. Simpan jadwal terbaru dan periksa perubahan menjelang pelaksanaan.

Sistem contoh ini tidak terhubung dengan kalender akademik langsung, sehingga belum dapat memberikan tanggal UTS yang pasti. Gunakan sumber resmi kampus untuk tanggal terbaru.','uts|ujian tengah semester|jadwal ujian');
INSERT INTO "faq" VALUES(3,'Bagaimana melihat jadwal kuliah?','Akademik','Cara melihat jadwal perkuliahan','Jadwal perkuliahan menunjukkan mata kuliah, waktu, pengajar, kelas, dan lokasi atau media pembelajaran.

Langkah yang dapat dicoba:
1. Masuk ke sistem informasi akademik atau portal mahasiswa.
2. Cari menu Jadwal Kuliah, Kelas Saya, atau KRS semester aktif.
3. Pilih semester dan kelompok kelas yang sesuai.
4. Cocokkan setiap jadwal dengan KRS yang sudah disimpan.
5. Periksa informasi ruang kuliah, tautan kelas daring, dan pengumuman dosen.
6. Apabila terdapat benturan atau jadwal belum muncul, hubungi administrasi akademik dengan menyebutkan NIM, kelas, dan mata kuliah.

Jangan menggunakan jadwal semester sebelumnya sebagai acuan karena penempatan kelas dan pengajar dapat berubah.','jadwal kuliah|jadwal kelas|jadwal perkuliahan|mata kuliah');
INSERT INTO "faq" VALUES(4,'Saya ingin mengetahui nilai mata kuliah.','Akademik','Cara memeriksa nilai mata kuliah','Nilai mata kuliah biasanya dapat dilihat setelah proses penilaian dan pengesahan nilai diselesaikan pada sistem akademik.

Langkah pemeriksaan:
1. Masuk ke portal mahasiswa atau sistem informasi akademik.
2. Buka menu Kartu Hasil Studi (KHS), Nilai, atau Riwayat Akademik.
3. Pilih semester dan mata kuliah yang ingin diperiksa.
4. Pastikan nilai sudah berstatus final atau sudah dipublikasikan.
5. Bila nilai belum tampil, tanyakan status penginputan melalui kanal akademik yang ditetapkan.
6. Jika terdapat ketidaksesuaian, sampaikan identitas mata kuliah dan bukti pendukung sesuai prosedur peninjauan nilai.

Hindari membagikan kata sandi akun akademik atau tangkapan layar yang memuat data pribadi secara terbuka.','nilai|khs|kartu hasil studi');
INSERT INTO "faq" VALUES(5,'Bagaimana prosedur perubahan KRS?','Akademik','Prosedur perubahan KRS','Perubahan KRS biasanya dilakukan pada masa perubahan atau pembatalan mata kuliah yang ditetapkan dalam kalender akademik.

Alur umum:
1. Periksa apakah periode perubahan KRS masih dibuka.
2. Masuk ke sistem akademik dan buka KRS semester berjalan.
3. Tentukan mata kuliah yang akan ditambah, dikurangi, atau diganti.
4. Periksa kembali prasyarat, jumlah SKS, kapasitas kelas, dan benturan jadwal.
5. Ajukan perubahan dan ikuti proses persetujuan yang disyaratkan.
6. Simpan atau cetak KRS terbaru dan pastikan perubahan tercatat.

Jika periode telah ditutup atau muncul kendala sistem, jangan menganggap perubahan sudah sah. Hubungi dosen pembimbing akademik atau administrasi prodi untuk mendapatkan prosedur resmi.','ubah krs|perubahan krs|krs');
INSERT INTO "faq" VALUES(6,'Kapan pengisian KRS dibuka?','Akademik','Jadwal pembukaan KRS','Periode pembukaan KRS ditentukan melalui kalender akademik dan kebijakan registrasi semester dari kampus.

Untuk mengetahui jadwal yang benar:
1. Lihat kalender akademik resmi untuk tahun ajaran dan semester tujuan.
2. Periksa pengumuman sistem informasi akademik mengenai awal dan akhir pengisian.
3. Perhatikan apakah registrasi administrasi harus diselesaikan lebih dahulu.
4. Pastikan mata kuliah yang ditawarkan sudah muncul dalam sistem.
5. Catat tenggat pengisian, masa perubahan KRS, serta mekanisme persetujuan apabila ada.

Database contoh ini belum memuat tanggal kalender akademik yang tervalidasi. Karena itu, tanggal pembukaan KRS tidak boleh disimpulkan dari jawaban otomatis ini.','krs|kartu rencana studi');
INSERT INTO "faq" VALUES(7,'Saya membutuhkan surat aktif kuliah.','Administrasi','Pengajuan surat keterangan aktif kuliah','Surat Keterangan Aktif Kuliah adalah dokumen administrasi yang menerangkan status perkuliahan mahasiswa berdasarkan data resmi institusi.

Langkah umum pengajuan:
1. Pastikan status mahasiswa aktif pada semester yang dimaksud.
2. Hubungi loket akademik atau layanan administrasi program studi untuk mengetahui formulir permohonan yang berlaku.
3. Siapkan identitas mahasiswa, NIM, program studi, semester, dan tujuan penggunaan surat.
4. Lengkapi dokumen pendukung jika diminta, kemudian ajukan melalui saluran resmi.
5. Pantau proses pemeriksaan data dan penandatanganan oleh pejabat yang berwenang.
6. Periksa nama, NIM, tahun akademik, nomor surat, dan tujuan penggunaan ketika surat diterima.

Syarat, durasi layanan, dan pihak penandatangan bergantung pada ketentuan institusi. Jawaban ini merupakan panduan umum, bukan pengesahan status aktif mahasiswa.','surat aktif|aktif kuliah|keterangan aktif');
INSERT INTO "faq" VALUES(8,'Bagaimana cara mengurus surat mahasiswa?','Administrasi','Panduan pengurusan surat mahasiswa','Layanan surat mahasiswa dapat mencakup surat aktif kuliah, surat pengantar, surat izin, atau dokumen akademik lainnya. Jenis surat menentukan syarat dan jalur pengurusannya.

Tahapan yang disarankan:
1. Tentukan nama surat dan tujuan pengajuan secara spesifik.
2. Tanyakan persyaratan resmi kepada administrasi program studi atau unit akademik.
3. Siapkan NIM, identitas, kontak, dan berkas pendukung yang relevan.
4. Isi formulir atau permohonan melalui sistem yang ditetapkan.
5. Cek status verifikasi dan persetujuan; jangan berasumsi surat otomatis selesai saat formulir dikirim.
6. Setelah diterbitkan, periksa isi, nomor surat, dan tanda tangan yang berlaku.

Sebutkan jenis surat yang dibutuhkan agar petugas dapat memberikan persyaratan yang tepat.','surat mahasiswa|mengurus surat|surat');
INSERT INTO "faq" VALUES(9,'Di mana mengajukan surat keterangan?','Administrasi','Lokasi pengajuan surat keterangan','Pengajuan surat keterangan biasanya dilayani melalui administrasi program studi, bagian akademik, atau portal layanan surat institusi.

Langkah untuk menemukan jalur yang benar:
1. Periksa situs atau pengumuman resmi kampus mengenai layanan surat.
2. Hubungi administrasi prodi dan tanyakan apakah pengajuan dilakukan secara langsung atau daring.
3. Jelaskan jenis surat yang diminta, misalnya aktif kuliah, pengantar, atau keterangan akademik.
4. Tanyakan formulir, persyaratan, jam pelayanan, dan perkiraan waktu pemrosesan yang diumumkan secara resmi.
5. Simpan nomor tiket atau bukti permohonan jika layanan menggunakan sistem antrean.

Sistem ini tidak memiliki daftar loket, tautan formulir, maupun jam layanan kampus yang tervalidasi sehingga tidak menyebutkan alamat layanan tertentu.','surat keterangan|pengajuan surat|surat');
INSERT INTO "faq" VALUES(10,'Bagaimana prosedur legalisir dokumen?','Administrasi','Prosedur legalisasi dokumen akademik','Legalisasi dokumen merupakan proses pengesahan kesesuaian salinan dengan dokumen akademik yang sah.

Alur yang umum digunakan:
1. Pastikan jenis dokumen yang memerlukan legalisasi, misalnya transkrip atau ijazah.
2. Hubungi unit akademik penerbit untuk memeriksa ketentuan dan kewenangan legalisasi.
3. Siapkan dokumen asli serta salinan sesuai jumlah dan format yang diminta.
4. Lengkapi formulir permohonan serta verifikasi identitas bila diwajibkan.
5. Serahkan dokumen melalui layanan resmi dan simpan bukti penerimaan.
6. Periksa cap, tanda tangan, dan jumlah lembar setelah dokumen selesai.

Jangan menyerahkan dokumen asli kepada pihak yang tidak berwenang. Biaya dan lama proses harus dikonfirmasi pada pengumuman resmi institusi.','legalisir transkrip|legalisir|legalisasi|pengesahan dokumen');
INSERT INTO "faq" VALUES(11,'Saya ingin mengurus transkrip.','Administrasi','Pengurusan transkrip akademik','Transkrip akademik berisi rekam hasil studi mahasiswa. Prosedur penerbitan dapat berbeda antara transkrip sementara dan transkrip final.

Langkah pengurusan:
1. Tentukan apakah yang dibutuhkan adalah transkrip sementara, transkrip resmi, atau salinan yang dilegalisasi.
2. Periksa status nilai yang sudah diterbitkan di sistem akademik.
3. Hubungi bagian akademik untuk mengetahui persyaratan dan pejabat penerbit yang berlaku.
4. Lengkapi identitas mahasiswa, NIM, tujuan permohonan, dan berkas yang diperlukan.
5. Ajukan permohonan melalui kanal resmi dan ikuti proses verifikasi.
6. Setelah diterbitkan, periksa nama, NIM, daftar mata kuliah, nilai, SKS, dan pengesahannya.

Jika terdapat nilai yang belum final atau data tidak cocok, ajukan pengecekan terlebih dahulu sebelum menggunakan transkrip untuk keperluan resmi.','transkrip|transcript');
INSERT INTO "faq" VALUES(12,'Bagaimana prosedur administrasi akademik?','Administrasi','Alur layanan administrasi akademik','Administrasi akademik mencakup berbagai layanan, antara lain permohonan surat, verifikasi status studi, dokumen hasil belajar, dan perubahan data akademik.

Tahapan awal yang bisa diikuti:
1. Identifikasi layanan yang dibutuhkan dan unit yang bertanggung jawab.
2. Periksa syarat layanan pada portal atau pengumuman resmi kampus.
3. Siapkan NIM, identitas, formulir, dan berkas pendukung yang sesuai.
4. Ajukan permohonan melalui saluran institusi yang sah.
5. Catat bukti permohonan dan pantau status pemeriksaan atau persetujuan.
6. Setelah selesai, cocokkan keluaran layanan dengan data akademik mahasiswa.

Setiap layanan mempunyai aturan dan waktu proses yang berbeda. Sebutkan jenis administrasi yang ingin diurus agar panduan dapat dibuat lebih spesifik.','administrasi akademik|administrasi|layanan akademik');
INSERT INTO "faq" VALUES(13,'WiFi kampus tidak bisa terhubung.','Teknis','Penanganan masalah Wi-Fi kampus','Gangguan Wi-Fi dapat terjadi karena pengaturan perangkat, sinyal, autentikasi, atau layanan jaringan sedang bermasalah.

Pemeriksaan awal:
1. Pastikan mode pesawat mati dan Wi-Fi perangkat aktif.
2. Periksa apakah nama jaringan kampus terlihat dan sinyalnya cukup kuat.
3. Putuskan koneksi lalu sambungkan kembali dengan kredensial resmi yang masih berlaku.
4. Jika muncul halaman autentikasi, selesaikan proses masuk melalui portal resmi.
5. Coba gunakan perangkat lain untuk membedakan gangguan pada satu perangkat atau banyak pengguna.
6. Jika tetap gagal, laporkan lokasi, waktu kejadian, nama jaringan (SSID), jenis perangkat, dan pesan kesalahan kepada petugas TI.

Jangan membagikan kata sandi akun. Jangan mengubah konfigurasi jaringan kampus tanpa izin pengelola.','wifi|wi-fi|wireless|internet kampus');
INSERT INTO "faq" VALUES(14,'Saya tidak bisa login ke LMS.','Teknis','Mengatasi gagal masuk LMS','Masalah login pada Learning Management System (LMS) bisa disebabkan oleh kesalahan akun, sesi peramban, atau gangguan layanan.

Coba langkah berikut:
1. Pastikan alamat situs LMS sesuai pengumuman resmi kampus.
2. Periksa penulisan nama pengguna dan kata sandi, termasuk huruf besar dan kecil.
3. Periksa apakah akun sudah aktif dan terdaftar pada semester berjalan.
4. Gunakan mode privat peramban atau hapus cache situs, kemudian coba lagi.
5. Jika tersedia, manfaatkan fitur pemulihan kata sandi resmi.
6. Bila masalah berlanjut, kirimkan waktu kejadian, jenis perangkat, dan tangkapan layar pesan kesalahan kepada pengelola LMS tanpa memperlihatkan kata sandi.

Jangan memasukkan kredensial pada tautan yang belum diverifikasi sebagai situs resmi.','lms|e-learning|elearning|moodle');
INSERT INTO "faq" VALUES(15,'Komputer laboratorium tidak menyala.','Teknis','Komputer laboratorium tidak dapat dinyalakan','Jika komputer laboratorium tidak menyala, prioritaskan keselamatan dan ikuti ketentuan penggunaan fasilitas kampus.

Langkah yang aman:
1. Periksa apakah tombol daya pada komputer sudah ditekan dengan benar.
2. Amati apakah monitor menyala namun komputer tidak menampilkan gambar.
3. Bila diperbolehkan petugas, periksa sambungan kabel daya dari luar tanpa membuka casing atau menyentuh instalasi listrik terbuka.
4. Periksa apakah perangkat lain pada meja atau ruangan mengalami gangguan serupa.
5. Catat nomor komputer, ruangan, waktu kejadian, dan gejala seperti lampu indikator atau bunyi tertentu.
6. Laporkan kepada laboran atau teknisi; hentikan penggunaan bila tercium bau hangus, terlihat percikan, atau kabel rusak.

Jangan membongkar komponen dan jangan melakukan perbaikan kelistrikan sendiri.','komputer laboratorium|komputer lab|laboratorium|lab');
INSERT INTO "faq" VALUES(16,'Website kampus menampilkan error.','Teknis','Penanganan error website kampus','Kesalahan saat membuka website dapat berasal dari peramban, koneksi internet, atau gangguan server.

Pemeriksaan yang dapat dilakukan:
1. Catat alamat halaman yang diakses dan pesan kesalahan yang tampil.
2. Muat ulang halaman satu kali dan periksa apakah internet berfungsi pada situs lain.
3. Coba buka halaman melalui peramban lain atau mode privat.
4. Jika memakai jaringan tertentu, coba jaringan alternatif yang sah untuk membandingkan hasil.
5. Hindari mengirim formulir berulang kali apabila sebelumnya sudah menekan tombol simpan atau bayar.
6. Laporkan waktu kejadian, alamat halaman, dan pesan error kepada pengelola website.

Jangan mengunggah data rahasia atau mencoba menembus sistem ketika menemukan kesalahan teknis. Status server yang sebenarnya hanya dapat dipastikan oleh pengelola.','website kampus|web kampus|situs kampus|portal kampus');
INSERT INTO "faq" VALUES(17,'Aplikasi kampus tidak bisa dibuka.','Teknis','Aplikasi kampus tidak dapat dibuka','Aplikasi yang gagal dibuka bisa terkait versi aplikasi, kompatibilitas perangkat, koneksi jaringan, atau layanan yang sedang terganggu.

Langkah awal:
1. Pastikan perangkat memiliki koneksi internet bila aplikasi memerlukannya.
2. Tutup aplikasi lalu buka kembali; periksa apakah masalah hanya terjadi pada aplikasi tersebut.
3. Periksa informasi pembaruan dari sumber atau toko aplikasi resmi.
4. Jika berupa aplikasi web, coba peramban lain dan periksa pesan kesalahan.
5. Jika aplikasi terhenti saat dibuka, catat versi sistem operasi, versi aplikasi, dan langkah yang memicu kesalahan.
6. Hubungi dukungan TI kampus dengan rincian masalah tanpa membagikan kata sandi atau kode verifikasi.

Hindari menghapus data aplikasi atau memasang ulang sebelum memastikan data penting sudah tersimpan atau tersinkron.','aplikasi kampus|app kampus|aplikasi akademik');
INSERT INTO "faq" VALUES(18,'Saya mengalami masalah pada jaringan.','Teknis','Diagnostik awal gangguan jaringan','Gangguan jaringan bisa muncul sebagai koneksi lambat, terputus-putus, atau tidak dapat mengakses layanan tertentu.

Langkah diagnosis dasar:
1. Catat apakah masalah dialami pada Wi-Fi, kabel LAN, atau jaringan seluler.
2. Periksa apakah perangkat mendapat koneksi dan apakah aplikasi lain masih dapat mengakses internet.
3. Bandingkan dengan perangkat lain pada jaringan yang sama.
4. Bila menggunakan Wi-Fi, periksa sinyal dan coba berpindah ke lokasi dengan cakupan lebih baik.
5. Catat sejak kapan gangguan terjadi dan layanan atau alamat yang tidak dapat diakses.
6. Laporkan kepada pengelola jaringan beserta lokasi, perangkat, dan pesan kesalahan yang muncul.

Jangan mengubah pengaturan router atau perangkat jaringan milik kampus tanpa izin pengelola.','jaringan|kabel lan|koneksi internet|network');
CREATE TABLE kategori (
                nama TEXT PRIMARY KEY,
                deskripsi TEXT NOT NULL,
                panduan_umum TEXT NOT NULL
            );
INSERT INTO "kategori" VALUES('Akademik','Pertanyaan seputar KRS, jadwal kuliah, nilai, dan kegiatan akademik.','Pertanyaan Anda terdeteksi berkaitan dengan layanan akademik, tetapi belum cukup mirip dengan pertanyaan yang tersedia dalam basis pengetahuan.

Agar informasi lebih tepat, sebutkan layanan yang dimaksud, misalnya pengisian atau perubahan KRS, nilai, jadwal perkuliahan, maupun jadwal ujian. Jelaskan pula kendala atau langkah yang sudah dicoba.

Untuk informasi yang berubah setiap semester, seperti tanggal, kelas, batas SKS, dan kebijakan resmi, periksa sistem akademik atau hubungi petugas program studi. Sistem contoh ini tidak memiliki data akademik langsung.');
INSERT INTO "kategori" VALUES('Administrasi','Pertanyaan seputar surat dan dokumen layanan mahasiswa.','Pertanyaan Anda terdeteksi berkaitan dengan administrasi mahasiswa, namun belum ditemukan jawaban rinci yang benar-benar sesuai.

Sebutkan jenis dokumen atau layanan yang dibutuhkan, seperti surat aktif kuliah, transkrip, legalisasi, atau pengajuan surat lainnya. Lengkapi dengan tujuan permohonan dan jenis kendala yang dihadapi, tanpa membagikan data pribadi sensitif.

Syarat dokumen, alur persetujuan, serta durasi layanan harus dikonfirmasi melalui administrasi program studi atau bagian akademik yang berwenang.');
INSERT INTO "kategori" VALUES('Teknis','Pertanyaan seputar Wi-Fi, jaringan, laboratorium, LMS, dan aplikasi kampus.','Pertanyaan Anda tampaknya berhubungan dengan kendala teknis, tetapi penjelasan yang diberikan belum cukup untuk memilih panduan khusus.

Untuk membantu diagnosis, tuliskan nama layanan atau perangkat yang bermasalah, pesan kesalahan yang muncul, waktu kejadian, serta langkah yang sudah dicoba. Contohnya: tidak bisa masuk LMS, Wi-Fi gagal tersambung, atau komputer laboratorium tidak menyala.

Jangan mengirim kata sandi, kode OTP, atau informasi rahasia. Untuk gangguan server maupun perangkat milik kampus, petugas TI perlu memverifikasi kondisi aktualnya.');
CREATE INDEX idx_data_latih_kategori ON data_latih(kategori);
CREATE INDEX idx_faq_kategori ON faq(kategori);
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('data_latih',18);
INSERT INTO "sqlite_sequence" VALUES('faq',18);
COMMIT;
PRAGMA foreign_keys = ON;
