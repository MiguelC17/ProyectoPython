# src/Home.py ---- => Para ejecutarse me paro en frontend/src y ejecuto el comando ""python -m streamlit run Home.py""
import streamlit as st

st.set_page_config(page_title="Mi Red Social", page_icon="💬", layout="centered")

st.title("💬 Bienvenido a Mi Red Social")

st.write("""
Esta es una aplicación simple tipo red social creada con **Streamlit**.
Navega por las páginas de la izquierda para:
- 📝 Registrar un usuario
- 🔐 Iniciar sesión
- 🧱 Ver el muro de publicaciones
""")

st.success("Selecciona una opción en el menú lateral 👈")
