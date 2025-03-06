from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import uvicorn
import cv2
import numpy as np
import tensorflow as tf
import pandas as pd
import os
import json
from deep_translator import GoogleTranslator

app = FastAPI()

# Enable CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load your model and CSV file
model = tf.keras.models.load_model('./myModel.h5')
df = pd.read_csv('./p4.csv')

# Initialize the translator
translator = GoogleTranslator(source='en', target='es')

# Cache setup
CACHE_FILE = "translation_cache.json"
translation_cache = {}

# Dictionary of known manual translations for problematic cases
MANUAL_TRANSLATIONS = {
    "Limited options: Once symptoms appear, treatment options are limited.Severe cases: In severe cases, heavily infected plants may need to be removed and destroyed to prevent further spread within the garden.Fungicides: In less severe cases, copper fungicides may still be applied to suppress the spread of the bacteria on the leaves.Hygiene: Maintain good garden hygiene by removing infected leaves and debris, and avoid working with wet plants to minimize the risk of further spreading La bacteria.": 
    "Opciones limitadas: Una vez que aparecen los síntomas, las opciones de tratamiento son limitadas. Casos graves: En casos graves, las plantas muy infectadas infectadas deben ser eliminadas y destruidas Fungicidas: En casos casos menos graves, pueden aplicarse fungicidas para suprimir la propagación de la bacteria en las hojas. Higiene: Mantenga una buena higiene higiene del jardín eliminando las hojas infectadas y los residuos, y evite trabajar con plantas húmedas para minimizar el riesgo de propagación de la bacteria."
}

# Normalizer function to handle special characters
def normalize_special_chars(text):
    # Specific replacements for common encoding issues
    replacements = {
        'Ã¡': 'á',
        'Ã©': 'é',
        'Ã­': 'í',
        'Ã³': 'ó',
        'Ãº': 'ú',
        'Ã±': 'ñ',
        'Ã': 'Á',
        'Ã‰': 'É',
        'Ã': 'Í',
        'Ã"': 'Ó',
        'Ãš': 'Ú',
        'Ã': 'Ñ',
        'Â¿': '¿',
        'Â¡': '¡'
    }
    
    # Apply replacements
    for wrong, correct in replacements.items():
        text = text.replace(wrong, correct)
    
    return text

# Load cache if it exists
def load_cache():
    global translation_cache
    try:
        if os.path.exists(CACHE_FILE):
            with open(CACHE_FILE, 'r', encoding='utf-8') as f:
                translation_cache = json.load(f)
                
            # Normalize all cached translations
            normalized_cache = {}
            for key, value in translation_cache.items():
                normalized_cache[key] = normalize_special_chars(value)
            
            translation_cache = normalized_cache
            print(f"Loaded {len(translation_cache)} cached translations")
    except Exception as e:
        print(f"Error loading cache: {e}")
        translation_cache = {}

# Save cache
def save_cache():
    try:
        with open(CACHE_FILE, 'w', encoding='utf-8') as f:
            json.dump(translation_cache, f, ensure_ascii=False, indent=2)
        print(f"Saved {len(translation_cache)} translations to cache")
    except Exception as e:
        print(f"Error saving cache: {e}")

# Translate from English to Español
def translate_text(text, is_treatment=False):
    if pd.isna(text) or text == "":
        return "No disponible"
    
    # For treatments, check manual translations first
    if is_treatment:
        # Try exact match
        if text in MANUAL_TRANSLATIONS:
            return MANUAL_TRANSLATIONS[text]
        
        # Try partial match for known phrases
        for eng, esp in MANUAL_TRANSLATIONS.items():
            if eng in text:
                print(f"Found partial match: {eng}")
                return esp
    
    # Check cache
    cache_key = f"treatment:{text}" if is_treatment else text
    if cache_key in translation_cache:
        return translation_cache[cache_key]
    
    try:
        # Special handling for "Limited options" text which seems problematic
        if text.startswith("Limited options"):
            translated = "Opciones limitadas: Una vez que aparecen los síntomas, las opciones de tratamiento son limitadas. En casos graves, las plantas muy infectadas pueden necesitar ser eliminadas y destruidas para prevenir una mayor propagación dentro del jardín. En casos menos graves, todavía se pueden aplicar fungicidas de cobre para suprimir la propagación de la bacteria en las hojas. Mantener una buena higiene en el jardín eliminando hojas infectadas y residuos, y evitar trabajar con plantas mojadas para minimizar el riesgo de una mayor propagación de la bacteria."
        elif is_treatment and len(text) > 200:
            # Split into sentences for long treatment text
            chunks = [s.strip() for s in text.split('.') if s.strip()]
            translated_chunks = []
            
            for chunk in chunks:
                # Translate each chunk
                try:
                    chunk_translated = translator.translate(chunk)
                    chunk_translated = normalize_special_chars(chunk_translated)
                    translated_chunks.append(chunk_translated)
                except Exception as e:
                    print(f"Error translating chunk: {e}")
                    translated_chunks.append(chunk)  # Use original if translation fails
            
            # Join back together
            translated = '. '.join(translated_chunks)
            if not translated.endswith('.'):
                translated += '.'
        else:
            # Normal translation
            translated = translator.translate(text)
            translated = normalize_special_chars(translated)
        
        # Add to cache
        translation_cache[cache_key] = translated
        
        # Save cache periodically
        if len(translation_cache) % 10 == 0:
            save_cache()
            
        return translated
    except Exception as e:
        print(f"Error in translation: {e}")
        print(f"Text that caused error: {text[:100]}...")
        
        # For treatment text, provide a fallback
        if is_treatment:
            if "Limited options" in text:
                return "Opciones limitadas: Una vez que aparecen los síntomas, las opciones de tratamiento son limitadas."
            elif "No treatment" in text:
                return "No se necesita tratamiento"
        
        return text  # Return the original text if translation fails

# Preprocess image as per model's requirement
def preprocess_image(image_path):
    image = cv2.imread(image_path)
    image = cv2.resize(image, (224, 224))
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    image = image.astype(np.float32)
    image = np.expand_dims(image, axis=0)
    return image

@app.get("/get")
async def get():
    return JSONResponse(content={"message": "API is hitting perfectly"})

@app.post("/predict")
async def predict(image: UploadFile = File(...)):
    image_path = f"./{image.filename}"
    
    # Save the uploaded image
    with open(image_path, "wb") as image_file:
        content = await image.read()
        image_file.write(content)
    print(f"Image saved at: {image_path}")
    
    # Preprocess the image and make a prediction
    processed_image = preprocess_image(image_path)
    prediction = model.predict(processed_image)

    # Get the top 3 predictions
    top3_indices = np.argsort(prediction[0])[-3:][::-1]
    top3_class_names = [df.iloc[i]['Label'] for i in top3_indices]
    top3_scores = prediction[0][top3_indices]
    top3_percentages = top3_scores / np.sum(top3_scores) * 100

    # Prepare the response
    response = {}
    for i in range(3):
        index = top3_indices[i]
        treatment = df.iloc[index]['Treatment']
        if pd.isna(treatment):
            treatment = "No treatment needed"

        # Translate the description and prevention text to Spanish
        class_name_es = translate_text(top3_class_names[i])
        description_es = translate_text(df.iloc[index]['Description'])
        prevention_es = translate_text(df.iloc[index]['Prevention'])
        
        # Special handling for treatment
        treatment_es = translate_text(treatment, is_treatment=True)
        
        # Debug output to see what's happening
        print(f"Original treatment: {treatment[:100]}...")
        print(f"Translated treatment: {treatment_es[:100]}...")

        response[f"prediction_{i+1}"] = {
            "class_name": top3_class_names[i],
            "class_name_es": class_name_es,
            "confidence": f"{top3_percentages[i]:.2f}%",
            "example_picture": df.iloc[index]['Example Picture'],
            "description": df.iloc[index]['Description'],
            "description_es": description_es,
            "prevention": df.iloc[index]['Prevention'],
            "prevention_es": prevention_es,
            "treatment": treatment,
            "treatment_es": treatment_es
        }
    
    # Delete the saved image after processing
    os.remove(image_path)

    # Ensure proper encoding in the JSON response
    return JSONResponse(
        content=response,
        media_type="application/json; charset=utf-8"
    )
    
# Initialize cache when app starts
@app.on_event("startup")
async def startup_event():
    # First, try to delete the old cache file to start fresh
    try:
        if os.path.exists(CACHE_FILE):
            os.remove(CACHE_FILE)
            print(f"Deleted old cache file: {CACHE_FILE}")
    except Exception as e:
        print(f"Error deleting cache file: {e}")
    
    # Initialize an empty cache
    load_cache()

# Save cache when app shuts down
@app.on_event("shutdown")
async def shutdown_event():
    save_cache()

if __name__ == "__main__":
    uvicorn.run(
        app, 
        host="0.0.0.0", 
        port=80
    )