# Reconocimiento de Enfermedades de Plantas con IA

## 📱 Descripción del Proyecto

Este proyecto consiste en una aplicación móvil desarrollada en **Flutter** que utiliza inteligencia artificial para detectar y clasificar enfermedades en plantas a través del análisis de imágenes. La aplicación incluye un backend en **Python** con **FastAPI** y un modelo de machine learning entrenado con **TensorFlow**.

## 🏗️ Arquitectura del Proyecto

El proyecto está dividido en tres componentes principales:

### 1. `rec_enfermedades_plantas_ia/` - Aplicación Móvil Flutter
- **Framework**: Flutter
- **Lenguaje**: Dart
- **Funcionalidades**:
  - Captura de imágenes de plantas mediante cámara
  - Selección de imágenes desde galería
  - Predicción de enfermedades usando IA
  - Historial de predicciones con base de datos local
  - Interfaz multiidioma (Español/Inglés)
  - Páginas informativas y créditos

### 2. `rec_enfermedades_plantas_ia_backend/` - API Backend
- **Framework**: FastAPI
- **Lenguaje**: Python
- **Funcionalidades**:
  - API REST para procesamiento de imágenes
  - Modelo de TensorFlow integrado
  - Procesamiento de imágenes con OpenCV
  - Traducción automática de resultados
  - Soporte CORS para aplicaciones móviles

### 3. `rec_enfermedades_plantas_ia_model/` - Entrenamiento del Modelo
- **Framework**: TensorFlow/Keras
- **Ambiente**: Jupyter Notebook
- **Contenido**:
  - Notebook de entrenamiento del modelo
  - Modelo entrenado (.h5)
  - Modelo optimizado para móviles (.tflite)
  - Dataset de entrenamiento (p4.csv)

## 🛠️ Tecnologías Utilizadas

### Frontend (Flutter)
- **Flutter SDK** ^3.5.4
- **Dart**
- **image_picker** ^0.8.5+3 - Captura de imágenes
- **http** ^1.2.1 - Comunicación con API
- **sqflite** ^2.0.0+3 - Base de datos local
- **path** ^1.9.0 - Manejo de rutas

### Backend (Python)
- **FastAPI** - Framework web
- **TensorFlow** 2.15.0 - Machine Learning
- **OpenCV** - Procesamiento de imágenes
- **Pandas** - Manipulación de datos
- **NumPy** - Computación numérica
- **deep_translator** - Traducción automática
- **Flask-CORS** - Manejo de CORS

### Machine Learning
- **TensorFlow/Keras** - Entrenamiento del modelo
- **MobileNetV2** - Arquitectura de red neuronal
- **scikit-learn** - Métricas y evaluación
- **OpenCV** - Procesamiento de imágenes
- **Matplotlib/Seaborn** - Visualización

## 📋 Requisitos Previos

### Para la Aplicación Flutter:
- Flutter SDK 3.5.4 o superior
- Dart SDK
- Android Studio o VS Code
- Dispositivo Android/iOS o emulador

### Para el Backend:
- Python 3.10 o superior
- pip (gestor de paquetes de Python)

### Para el Entrenamiento del Modelo:
- Jupyter Notebook
- GPU recomendada para entrenamiento (CUDA compatible)

## 🚀 Instalación y Configuración

### 1. Clonar el Repositorio
```bash
git clone [URL_DEL_REPOSITORIO]
cd Proyecto
```

### 2. Configurar el Backend

```bash
cd rec_enfermedades_plantas_ia_backend

# Crear entorno virtual (recomendado)
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate

# Instalar dependencias
pip install -r requirements.txt

# Ejecutar el servidor
python predict.py
```

El servidor estará disponible en `http://localhost:8000`

### 3. Configurar la Aplicación Flutter

```bash
cd rec_enfermedades_plantas_ia

# Obtener dependencias
flutter pub get

# Ejecutar la aplicación
flutter run
```

### 4. Docker (Opcional)

Para ejecutar el backend con Docker:

```bash
cd rec_enfermedades_plantas_ia_backend
docker build -t plant-disease-api .
docker run -p 8000:8000 plant-disease-api
```

## 📱 Funcionalidades de la Aplicación

### Pantallas Principales:
- **Splash Screen**: Pantalla de bienvenida
- **Menú Principal**: Navegación principal
- **Predicción**: Captura/selección de imágenes y análisis
- **Historial**: Registro de predicciones anteriores
- **Detalles**: Información detallada de cada predicción
- **Acerca de**: Información de la aplicación
- **Créditos**: Reconocimientos y autoría

### Características:
- ✅ Detección automática de enfermedades en plantas
- ✅ Base de datos local para historial
- ✅ Interfaz bilingüe (Español/Inglés)
- ✅ Captura desde cámara o galería
- ✅ Resultados con porcentaje de confianza
- ✅ Diseño Material Design

## 🤖 Modelo de IA

### Características del Modelo:
- **Arquitectura**: MobileNetV2 (optimizada para móviles)
- **Tipo**: Clasificación de imágenes
- **Formato**: TensorFlow (.h5) y TensorFlow Lite (.tflite)
- **Clases**: Múltiples enfermedades de plantas
- **Preprocesamiento**: Redimensionamiento y normalización automática

### Pipeline de Predicción:
1. Captura/selección de imagen
2. Envío al backend via API REST
3. Preprocesamiento de imagen
4. Inferencia del modelo
5. Post-procesamiento y traducción
6. Retorno de resultados con confianza

## 📂 Estructura de Archivos

```
Proyecto/
├── rec_enfermedades_plantas_ia/          # App Flutter
│   ├── android/                          # Configuración Android
│   ├── ios/                              # Configuración iOS
│   ├── lib/                              # Código fuente Dart
│   │   ├── controllers/                  # Controladores
│   │   ├── models/                       # Modelos de datos
│   │   ├── utils/                        # Utilidades
│   │   ├── views/                        # Pantallas UI
│   │   ├── database.dart                 # Manejo de BD
│   │   └── main.dart                     # Punto de entrada
│   ├── assets/                           # Recursos (imágenes, iconos)
│   └── pubspec.yaml                      # Dependencias Flutter
├── rec_enfermedades_plantas_ia_backend/  # Backend Python
│   ├── predict.py                        # API principal
│   ├── requirements.txt                  # Dependencias Python
│   ├── Dockerfile                        # Configuración Docker
│   ├── myModel.h5                        # Modelo entrenado
│   └── p4.csv                            # Dataset
└── rec_enfermedades_plantas_ia_model/    # Entrenamiento
    ├── Notebook.ipynb                    # Jupyter Notebook
    ├── myModel.h5                        # Modelo TensorFlow
    ├── myModel.tflite                    # Modelo optimizado
    └── p4.csv                            # Dataset de entrenamiento
```

## 🔧 API Endpoints

### Backend FastAPI

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/predict` | Análisis de imagen para detección de enfermedades |
| GET | `/health` | Estado del servicio |

**Ejemplo de uso:**
```python
import requests

url = "http://localhost:8000/predict"
files = {"file": open("plant_image.jpg", "rb")}
response = requests.post(url, files=files)
result = response.json()
```

## 🧪 Testing

### Ejecutar Tests Flutter:
```bash
cd rec_enfermedades_plantas_ia
flutter test
```

### Ejecutar Tests Backend:
```bash
cd rec_enfermedades_plantas_ia_backend
python -m pytest tests/
```

## 📊 Performance

- **Tiempo de predicción**: < 2 segundos
- **Precisión del modelo**: Variable según la enfermedad
- **Tamaño de la app**: ~50MB
- **Compatibilidad**: Android 5.0+, iOS 12.0+

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

## 🙏 Agradecimientos

- Dataset de enfermedades de plantas de Kaggle
- Comunidad de Flutter y TensorFlow
- Contribuidores de librerías open source utilizadas

## 📞 Soporte

Para reportar bugs o solicitar nuevas características, por favor crear un issue en el repositorio.

---

**Nota**: Este proyecto fue desarrollado con fines educativos para la materia de Desarrollo de Aplicaciones Móviles.
