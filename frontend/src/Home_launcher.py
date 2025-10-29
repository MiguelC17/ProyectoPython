# frontend/src/Home_launcher.py
# Ejecuta el script real que está dentro de pages/ para que Streamlit detecte la carpeta pages/
import runpy
import os

# ruta al script Home dentro de pages
script_path = os.path.join(os.path.dirname(__file__), "pages", "Home.py")
runpy.run_path(script_path, run_name="__main__")
