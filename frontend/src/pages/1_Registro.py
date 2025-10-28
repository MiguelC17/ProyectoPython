# src/pages/1_Registro.py
import streamlit as st

st.title("📝 Registro de Usuario")

nombre = st.text_input("Nombre de usuario")
email = st.text_input("Correo electrónico")
password = st.text_input("Contraseña", type="password")

if st.button("Registrar"):
    if nombre and email and password:
        st.success(f"Usuario '{nombre}' registrado con éxito ✅")
    else:
        st.error("Por favor completa todos los campos.")
 