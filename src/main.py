import tkinter as tk
from tkinter import ttk
root = tk.Tk()
root.title ("Smart Helpdesk Classifier")
root. geometry("720x500")
root.minsize (600, 400)
title = ttk.Label(
root,
text="Smart Helpdesk Classifier",
font=("Arial", 18, "bold")
)
title.pack(pady=(20,5))
subtitle = ttk.Label(
root,
text = "Prototype Klasifikasi pertanyaan berbasis Python")
subtitle.pack(pady=(0,15))
root.mainloop()
