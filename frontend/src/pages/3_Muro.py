# src/pages/3_Muro.py
import streamlit as st

st.title("🧱 Muro de Publicaciones")

# Verifica si hay un usuario logueado
if "usuario" not in st.session_state:
    st.warning("Debes iniciar sesión antes de publicar.")
    st.stop()

usuario = st.session_state["usuario"]

st.subheader(f"Hola {usuario}, publica algo:")

# Inicializa la lista de publicaciones en la sesión
if "publicaciones" not in st.session_state:
    st.session_state["publicaciones"] = []

# Campo de texto para nueva publicación
nuevo_post = st.text_area("¿Qué estás pensando?", height=100)

if st.button("Publicar"):
    if nuevo_post.strip():
        st.session_state["publicaciones"].insert(0, (usuario, nuevo_post))
        st.success("Publicación agregada al muro ✅")
    else:
        st.error("No puedes publicar un texto vacío.")

st.divider()
st.subheader("📰 Últimas publicaciones:")

if st.session_state["publicaciones"]:
    for autor, texto in st.session_state["publicaciones"]:
        with st.container():
            st.markdown(f"**{autor}** dice:")
            st.write(f"💭 {texto}")
            st.write("---")
else:
    st.info("Aún no hay publicaciones.")
