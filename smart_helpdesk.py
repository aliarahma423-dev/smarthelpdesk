"""Smart Helpdesk: Tkinter + SQLite + TF-IDF + Logistic Regression.

Database dapat dibuka dan diedit dengan DB Browser for SQLite.
Jalankan: python smart_helpdesk.py
"""
from pathlib import Path
import re
import sqlite3
import tkinter as tk
from tkinter import ttk, messagebox

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.pipeline import Pipeline


LOKASI_DB = Path(__file__).resolve().parent / "helpdesk.db"

# Ambang ini adalah aturan praktis untuk dataset contoh yang kecil,
# BUKAN ukuran ketepatan atau validasi statistik model.
AMBANG_FAQ = 0.32
AMBANG_KATEGORI = 0.44


def ambil_data_database(lokasi_db):
    """Membaca data dari SQLite tanpa menulis/mengubah isinya."""
    if not lokasi_db.is_file():
        raise FileNotFoundError(
            f"Database tidak ditemukan: {lokasi_db}\n"
            "Jalankan dahulu: python inisialisasi_database.py"
        )

    # URI mode=ro mencegah aplikasi tanpa sengaja membuat/menimpa database.
    uri = lokasi_db.as_uri() + "?mode=ro"
    with sqlite3.connect(uri, uri=True, timeout=10) as koneksi:
        koneksi.row_factory = sqlite3.Row
        data_latih = [
            dict(baris)
            for baris in koneksi.execute(
                "SELECT id, pertanyaan, kategori FROM data_latih ORDER BY id"
            )
        ]
        faq = [
            dict(baris)
            for baris in koneksi.execute(
                "SELECT id, pertanyaan, kategori, judul, jawaban, kata_kunci FROM faq ORDER BY id"
            )
        ]
        kategori = {
            baris["nama"]: dict(baris)
            for baris in koneksi.execute(
                "SELECT nama, deskripsi, panduan_umum FROM kategori ORDER BY nama"
            )
        }
    return data_latih, faq, kategori


def kata_kunci_cocok(pertanyaan, kolom_kata_kunci):
    """Temukan frasa pengenal topik; tidak menebak topik di luar basis data."""
    teks = re.sub(r"\s+", " ", pertanyaan.casefold()).strip()
    hasil = []
    for frasa in kolom_kata_kunci.split("|"):
        frasa = re.sub(r"\s+", " ", frasa.casefold()).strip()
        if frasa and re.search(r"(?<!\w)" + re.escape(frasa) + r"(?!\w)", teks):
            hasil.append(frasa)
    return hasil


class MesinHelpdesk:
    """Model klasifikasi + pencarian jawaban dari tabel FAQ SQLite."""

    def __init__(self, lokasi_db=LOKASI_DB):
        self.lokasi_db = Path(lokasi_db)
        self.muat_ulang()

    def muat_ulang(self):
        data_latih, faq, kategori = ambil_data_database(self.lokasi_db)
        if len(data_latih) < 2:
            raise ValueError("Tabel data_latih harus memiliki sedikitnya dua baris.")
        if len({baris["kategori"] for baris in data_latih}) < 2:
            raise ValueError("Data latih harus mencakup sedikitnya dua kategori berbeda.")
        if not faq:
            raise ValueError("Tabel faq masih kosong. Tambahkan jawaban melalui DB Browser.")
        if not kategori:
            raise ValueError("Tabel kategori masih kosong.")

        pertanyaan_latih = [baris["pertanyaan"] for baris in data_latih]
        label_latih = [baris["kategori"] for baris in data_latih]

        model_baru = Pipeline([
            ("tfidf", TfidfVectorizer(ngram_range=(1, 2), lowercase=True)),
            ("classifier", LogisticRegression(max_iter=1000)),
        ])
        model_baru.fit(pertanyaan_latih, label_latih)

        # Pencarian FAQ dibuat terpisah agar bisa menjawab pertanyaan tertentu,
        # bukan hanya mengembalikan label Akademik/Administrasi/Teknis.
        pencari_baru = TfidfVectorizer(
            analyzer="char_wb", ngram_range=(3, 5), lowercase=True
        )
        teks_faq = [
            f"{baris['pertanyaan']} {baris['judul']}" for baris in faq
        ]
        matriks_faq_baru = pencari_baru.fit_transform(teks_faq)

        # Ganti seluruh model sekaligus hanya setelah pelatihan berhasil.
        self.data_latih = data_latih
        self.faq = faq
        self.kategori = kategori
        self.model = model_baru
        self.pencari_faq = pencari_baru
        self.matriks_faq = matriks_faq_baru

    def jawab(self, pertanyaan):
        pertanyaan = pertanyaan.strip()
        if not pertanyaan:
            raise ValueError("Pertanyaan tidak boleh kosong.")

        peluang = self.model.predict_proba([pertanyaan])[0]
        indeks_kelas = int(peluang.argmax())
        kategori_model = str(self.model.classes_[indeks_kelas])
        skor_model = float(peluang[indeks_kelas])

        vektor_pertanyaan = self.pencari_faq.transform([pertanyaan])
        daftar_kemiripan = cosine_similarity(
            vektor_pertanyaan, self.matriks_faq
        )[0]
        cocok_topik = [
            (i, kata_kunci_cocok(pertanyaan, faq["kata_kunci"]))
            for i, faq in enumerate(self.faq)
        ]
        cocok_topik = [(i, frasa) for i, frasa in cocok_topik if frasa]

        if cocok_topik:
            # Urutkan menurut kemiripan pertanyaan; bonus kecil untuk frasa
            # multi-kata yang cocok agar topik spesifik didahulukan.
            indeks_faq = max(
                cocok_topik,
                key=lambda item: (
                    float(daftar_kemiripan[item[0]])
                    + min(0.16, max(len(f.split()) - 1 for f in item[1]) * 0.16)
                ),
            )[0]
        else:
            indeks_faq = int(daftar_kemiripan.argmax())

        skor_faq = float(daftar_kemiripan[indeks_faq])
        faq_terdekat = self.faq[indeks_faq]

        # Tanpa kata kunci akademik/administrasi/teknis, lebih aman meminta
        # klarifikasi daripada menjawab pertanyaan luar topik secara keliru.
        if cocok_topik and skor_faq >= AMBANG_FAQ:
            kategori_hasil = faq_terdekat["kategori"]
            judul = faq_terdekat["judul"]
            jawaban = faq_terdekat["jawaban"]
            metode = "Jawaban dari FAQ paling relevan"
            status = "ditemukan"
        elif cocok_topik and skor_model >= AMBANG_KATEGORI and kategori_model in self.kategori:
            kategori_hasil = kategori_model
            judul = "Panduan umum / perlu rincian pertanyaan"
            jawaban = self.kategori[kategori_model]["panduan_umum"]
            metode = "Panduan kategori (FAQ spesifik belum cocok)"
            status = "umum"
        else:
            kategori_hasil = "Belum dapat ditentukan"
            judul = "Pertanyaan perlu diperjelas"
            jawaban = (
                "Saya belum menemukan jawaban yang cukup sesuai dalam database.\n\n"
                "Coba tulis pertanyaan yang lebih spesifik. Contoh:\n"
                "• Bagaimana cara mengisi KRS?\n"
                "• Saya membutuhkan surat aktif kuliah.\n"
                "• Saya tidak bisa login ke LMS.\n\n"
                "Jika topik di luar layanan akademik, administrasi, atau teknis, "
                "sistem contoh ini mungkin belum mempunyai datanya. "
                "Pengelola dapat menambahkan contoh pertanyaan dan jawaban "
                "melalui DB Browser for SQLite."
            )
            metode = "Belum ada kecocokan yang memadai"
            status = "tidak_dikenal"

        return {
            "pertanyaan": pertanyaan,
            "kategori_model": kategori_model,
            "skor_model": skor_model,
            "kategori": kategori_hasil,
            "judul": judul,
            "jawaban": jawaban,
            "metode": metode,
            "status": status,
            "skor_faq": skor_faq,
            "judul_faq_terdekat": faq_terdekat["judul"],
        }


def format_hasil(hasil):
    return (
        f"KATEGORI HASIL: {hasil['kategori']}\n"
        f"TOPIK: {hasil['judul']}\n"
        f"Prediksi kategori model: {hasil['kategori_model']} "
        f"({hasil['skor_model'] * 100:.1f}%)\n"
        f"Kemiripan FAQ terdekat: {hasil['skor_faq'] * 100:.1f}%\n"
        f"Metode: {hasil['metode']}\n"
        "\n"
        "JAWABAN / PANDUAN\n"
        "────────────────────────────────────\n"
        f"{hasil['jawaban']}\n\n"
        "────────────────────────────────────\n"
        "Catatan: Skor adalah keluaran model dan kemiripan teks, bukan "
        "jaminan kebenaran jawaban. Panduan bersifat umum dan tidak "
        "menggantikan pengumuman resmi kampus."
    )


class AplikasiHelpdesk(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Smart Helpdesk Classifier — SQLite")
        self.geometry("920x750")
        self.minsize(740, 570)
        self._terakhir = ""
        self.mesin = MesinHelpdesk(LOKASI_DB)
        self._atur_tema()
        self._bangun_tampilan()
        self._perbarui_tabel()

    def _atur_tema(self):
        style = ttk.Style(self)
        if "clam" in style.theme_names():
            style.theme_use("clam")
        style.configure("Judul.TLabel", font=("Arial", 20, "bold"))
        style.configure("Subjudul.TLabel", font=("Arial", 10))
        style.configure("Bagian.TLabel", font=("Arial", 11, "bold"))
        style.configure("TButton", font=("Arial", 10), padding=(10, 8))
        style.configure("Treeview", rowheight=26)
        style.configure("Treeview.Heading", font=("Arial", 10, "bold"))

    def _bangun_tampilan(self):
        wadah = ttk.Frame(self, padding=17)
        wadah.pack(fill="both", expand=True)

        ttk.Label(
            wadah, text="Smart Helpdesk Classifier", style="Judul.TLabel"
        ).pack(anchor="w")
        ttk.Label(
            wadah,
            text="Python + SQLite (DB Browser) + TF-IDF + Logistic Regression",
            style="Subjudul.TLabel",
        ).pack(anchor="w", pady=(2, 12))

        self.tab = ttk.Notebook(wadah)
        self.tab.pack(fill="both", expand=True)
        tab_klasifikasi = ttk.Frame(self.tab, padding=13)
        tab_data = ttk.Frame(self.tab, padding=13)
        self.tab.add(tab_klasifikasi, text="Tanya Helpdesk")
        self.tab.add(tab_data, text="Lihat Basis Pengetahuan")

        ttk.Label(
            tab_klasifikasi,
            text="Masukkan pertanyaan atau keluhan:",
            style="Bagian.TLabel",
        ).pack(anchor="w")
        self.input_text = tk.Text(
            tab_klasifikasi,
            height=5,
            wrap="word",
            font=("Arial", 11),
            padx=10,
            pady=8,
            relief="solid",
            bd=1,
        )
        self.input_text.pack(fill="x", pady=(7, 10))
        self.input_text.bind("<Control-Return>", self._proses_pintasan)

        tombol = ttk.Frame(tab_klasifikasi)
        tombol.pack(fill="x", pady=(0, 12))
        ttk.Button(tombol, text="Proses Pertanyaan", command=self.proses_input).pack(
            side="left", padx=(0, 7)
        )
        ttk.Button(tombol, text="Bersihkan", command=self.bersihkan).pack(
            side="left", padx=(0, 7)
        )
        ttk.Button(tombol, text="Salin Jawaban", command=self.salin_hasil).pack(
            side="left", padx=(0, 7)
        )
        ttk.Button(
            tombol, text="Muat Ulang Database", command=self.muat_ulang_database
        ).pack(side="right")

        ttk.Label(
            tab_klasifikasi, text="Hasil dan jawaban:", style="Bagian.TLabel"
        ).pack(anchor="w", pady=(0, 6))

        wadah_hasil = ttk.Frame(tab_klasifikasi)
        wadah_hasil.pack(fill="both", expand=True)
        wadah_hasil.rowconfigure(0, weight=1)
        wadah_hasil.columnconfigure(0, weight=1)
        self.hasil_text = tk.Text(
            wadah_hasil,
            wrap="word",
            state="disabled",
            font=("Arial", 10),
            padx=14,
            pady=12,
            relief="solid",
            bd=1,
        )
        self.hasil_text.grid(row=0, column=0, sticky="nsew")
        skrol_hasil = ttk.Scrollbar(
            wadah_hasil, orient="vertical", command=self.hasil_text.yview
        )
        skrol_hasil.grid(row=0, column=1, sticky="ns")
        self.hasil_text.configure(yscrollcommand=skrol_hasil.set)
        self._tampilkan_hasil("Hasil klasifikasi dan panduan akan muncul di sini.")

        ttk.Label(
            tab_data,
            text="Daftar pertanyaan dan jawaban dari file helpdesk.db",
            style="Bagian.TLabel",
        ).pack(anchor="w", pady=(0, 6))
        ttk.Label(
            tab_data,
            text="Untuk menambah/mengedit data, gunakan DB Browser for SQLite, "
                 "simpan perubahan, lalu klik 'Muat Ulang Database'.",
            wraplength=820,
        ).pack(anchor="w", pady=(0, 10))

        frame_tabel = ttk.Frame(tab_data)
        frame_tabel.pack(fill="both", expand=True)
        frame_tabel.columnconfigure(0, weight=1)
        frame_tabel.rowconfigure(0, weight=1)
        self.tabel_faq = ttk.Treeview(
            frame_tabel,
            columns=("id", "kategori", "judul", "pertanyaan"),
            show="headings",
            selectmode="browse",
        )
        for nama, teks, lebar in [
            ("id", "ID", 45),
            ("kategori", "Kategori", 125),
            ("judul", "Topik", 235),
            ("pertanyaan", "Contoh pertanyaan", 355),
        ]:
            self.tabel_faq.heading(nama, text=teks)
            self.tabel_faq.column(nama, width=lebar, anchor="w", stretch=nama != "id")
        self.tabel_faq.grid(row=0, column=0, sticky="nsew")
        skrol_tabel = ttk.Scrollbar(frame_tabel, command=self.tabel_faq.yview)
        skrol_tabel.grid(row=0, column=1, sticky="ns")
        self.tabel_faq.configure(yscrollcommand=skrol_tabel.set)
        self.tabel_faq.bind("<<TreeviewSelect>>", self._tampilkan_faq_dipilih)

        ttk.Label(tab_data, text="Isi jawaban pada FAQ terpilih:").pack(
            anchor="w", pady=(12, 5)
        )
        wadah_pratinjau = ttk.Frame(tab_data)
        wadah_pratinjau.pack(fill="both", expand=True)
        self.pratinjau = tk.Text(
            wadah_pratinjau, height=10, wrap="word", state="disabled",
            font=("Arial", 10), padx=10, pady=7, relief="solid", bd=1,
        )
        self.pratinjau.pack(side="left", fill="both", expand=True)
        skrol_pratinjau = ttk.Scrollbar(
            wadah_pratinjau, orient="vertical", command=self.pratinjau.yview
        )
        skrol_pratinjau.pack(side="right", fill="y")
        self.pratinjau.configure(yscrollcommand=skrol_pratinjau.set)

        self.status_var = tk.StringVar()
        ttk.Label(wadah, textvariable=self.status_var).pack(
            anchor="w", pady=(9, 0)
        )
        self._perbarui_status()
        self.input_text.focus_set()

    @staticmethod
    def _ubah_teks(widget, teks):
        widget.configure(state="normal")
        widget.delete("1.0", tk.END)
        widget.insert("1.0", teks)
        widget.configure(state="disabled")

    def _tampilkan_hasil(self, teks):
        self._terakhir = teks
        self._ubah_teks(self.hasil_text, teks)
        self.hasil_text.yview_moveto(0)

    def _perbarui_status(self):
        self.status_var.set(
            f"Database: {self.mesin.lokasi_db.name} | "
            f"{len(self.mesin.data_latih)} data pelatihan | "
            f"{len(self.mesin.faq)} FAQ | "
            "Ctrl+Enter untuk memproses"
        )

    def _proses_pintasan(self, _event):
        self.proses_input()
        return "break"

    def proses_input(self):
        teks = self.input_text.get("1.0", tk.END).strip()
        if not teks:
            messagebox.showwarning(
                "Input Kosong", "Silakan masukkan pertanyaan terlebih dahulu."
            )
            return
        try:
            hasil = self.mesin.jawab(teks)
        except Exception as kesalahan:
            messagebox.showerror("Gagal Memproses", str(kesalahan))
            return
        self._tampilkan_hasil(format_hasil(hasil))

    def bersihkan(self):
        self.input_text.delete("1.0", tk.END)
        self._tampilkan_hasil("Hasil klasifikasi dan panduan akan muncul di sini.")
        self.input_text.focus_set()

    def salin_hasil(self):
        if not self._terakhir or self._terakhir.startswith("Hasil klasifikasi"):
            messagebox.showinfo("Belum Ada Jawaban", "Proses pertanyaan terlebih dahulu.")
            return
        self.clipboard_clear()
        self.clipboard_append(self._terakhir)
        messagebox.showinfo("Berhasil", "Jawaban sudah disalin ke clipboard.")

    def _perbarui_tabel(self):
        for item in self.tabel_faq.get_children():
            self.tabel_faq.delete(item)
        for baris in self.mesin.faq:
            self.tabel_faq.insert(
                "", "end", iid=str(baris["id"]),
                values=(baris["id"], baris["kategori"],
                        baris["judul"], baris["pertanyaan"]),
            )
        self._ubah_teks(self.pratinjau, "Pilih salah satu pertanyaan untuk melihat jawabannya.")

    def _tampilkan_faq_dipilih(self, _event):
        pilihan = self.tabel_faq.selection()
        if not pilihan:
            return
        try:
            id_dipilih = int(pilihan[0])
        except ValueError:
            return
        baris = next(
            (baris for baris in self.mesin.faq if baris["id"] == id_dipilih), None
        )
        if baris is not None:
            self._ubah_teks(
                self.pratinjau,
                f"{baris['judul']} [{baris['kategori']}]\n\n{baris['jawaban']}",
            )

    def muat_ulang_database(self):
        try:
            self.mesin.muat_ulang()
            self._perbarui_tabel()
            self._perbarui_status()
        except Exception as kesalahan:
            messagebox.showerror("Gagal Memuat Database", str(kesalahan))
            return
        messagebox.showinfo(
            "Database Dimuat",
            "Data terbaru telah dibaca dari SQLite dan model sudah dilatih ulang.",
        )


def main():
    try:
        aplikasi = AplikasiHelpdesk()
    except (FileNotFoundError, sqlite3.Error, ValueError) as kesalahan:
        # Bila Tkinter bisa ditampilkan, berikan pesan yang mudah dipahami.
        try:
            akar = tk.Tk()
            akar.withdraw()
            messagebox.showerror("Aplikasi Tidak Dapat Dibuka", str(kesalahan))
            akar.destroy()
        except tk.TclError:
            print(f"Kesalahan: {kesalahan}")
        return
    aplikasi.mainloop()


if __name__ == "__main__":
    main()
