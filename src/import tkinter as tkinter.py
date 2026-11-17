import tkinter as tkinter
from tkinter import ttk, messagebox
from sklearn.feature_extraction.text import Tfidfvectorizer
from sklearn.linear_model import logisticRegression
from sklearn.pipeline import pipeline
DATA_TRAINING = [
("Bagaimana cara mengisi KRS?", "Akademik"),
("Kapan jadwal UTS semester ini?", "Akademik"),
("Bagaimana melihat jadwal kuliah?", "Akademik"),
("Saya ingin menegtahui nilai mata kuliah.", "Akademik")
("Bagaimana prosedur perubahan KRS?", "Akademik"),
("Kapan pengisian KRS dibuka?", "Akademik"),
("Saya membutuhkan surat aktif kuliah.","Administrasi"),
("Bagaimana cara mengurus surat mahasiswa?", "Administrasi"),
("Di mana mengajukan surat keterangan?", "Administrasi"),
("Bagaimana prosedur legalisir dokumen?", "Administrasi"),
("Saya ingin mengurus transkip.","Administrasi"),
("Bagaimana prodedur administrasi akademik?","Administrasi"),
("Wifi kampus tidak bisa terhubung. ","Teknis"),
("Saya tidak bisa login ke LMS.","Teknis"),
("Komputer laboraturium tidak menyala.","Teknis"),
("Website kampus menampilkan error.","Teknis"),
("Aplikasi kampus tidak bisa dibuka.","Teknis"),
("Saya mengalami masalah pada jaringan.","Teknis"),
]
def buat_model():
texts = [item[0] for item in DATA TRAINING]
labels = [item[1] for item in DATA_TRAINING]
model = Pipeline([
( "tfidf",TfidfVectorizer()),
("Classifier",LogisticRegression(max_iter=1000))
])
model.fit(texts,labels)
return model
model = buat_model()
def proses_input():
teks = input_text.get("1.0", tk.END).strip()
if not teks:
messagebox.showwarning(
"Input kosong",
"Silahkan masukkan pertanyaan terlebih dahulu. "
)
return
prediksi = model.predict([teks])[0]
probabilitas = model.predict proba([teks]).max()
hasil_var.set(
f"Kategori: {prediksi}\n"
f"probabilitas kelas: {probabilitas:2f}"
)
def bersihkan ():
input_text.delete("1.0",tk.END)
hasil_var.set("Hasil akan tampil di sini.")
root = tk.Tk()
root.title("Smart Helpdesk Classifier")
root.geometry("720x520")
root.minsize(620,450)
main = ttk.Frame(root, padding=20)
main = pack(fill="both", expand=True)
ttk.Label(
main,
text="Smast Helpdesk Classifier",
font=("Arial",20,"bold")
).pack(pady=(0,5))
ttk.Label(
main,
text="Python GUI + Text Classification"
).pack(pady=(0,15))
ttk.Label(
main,
text="Masukkan pertanyaan atau keluhan:"
).pack (anchor='w')
input_text = tk.Text(
main,
height=8,
wrap="word"
)
input_text.pack(fill="x", pady=8)
button_frame = ttk.Frame(main)
button_Frame.pack(pady=8)
ttk.Button(
button Frame,
text="proses",
command=proses_input
).grid(row=0, column=0, padx=5)
ttk.Button(
button_frame,
text="Bersihkan",
command=bersihkan
).grid (row=0, column=1, padx=5)
ttk.Label(
main,
text="Hasil:",
font=("Arial", 11, "bold")
).pack(anchor="w", pady=(15,5))
hasil_var = tk.StringVar(
value= "Hasil akan tampil di sini."
)
ttk.Label(
main,
textvariable=hasil_var,
wramplength=650,
justify="left"
).pack(fill="x", anchor="w")
ttk.Label(
main,
text="Catatan: model menggunakan dataset latihan kecil."
). pack(anchor="w", pady=(25,0))
root.mainloop()
