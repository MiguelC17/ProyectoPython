
import streamlit as st

st.title("🔐 Iniciar Sesión")

usuario = st.text_input("Usuario")
contraseña = st.text_input("Contraseña", type="password")

if st.button("Ingresar"):
    if usuario and contraseña:
        st.session_state["usuario"] = usuario
        st.success(f"Bienvenido, {usuario} 👋")
    else:
        st.warning("Por favor completa los campos.")
