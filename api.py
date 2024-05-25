from flask import Flask, request, jsonify
import torch
from transformers import CLIPProcessor, CLIPModel
from PIL import Image
import base64
import io

app = Flask(__name__)

model = CLIPModel.from_pretrained("openai/clip-vit-base-patch32")
processor = CLIPProcessor.from_pretrained("openai/clip-vit-base-patch32")

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.json
        image_data = data['image']  # Base64 encoded image
        text = data['text']  # Text description
        
        print(f"Gelen metin: {text}")
        print(f"Gelen görüntü verisi: {image_data[:30]}...")
        
        if image_data.startswith('data:image'):
            base64_str_idx = image_data.find('base64,') + 7
            image_data = image_data[base64_str_idx:]
        
        image_decoded = base64.b64decode(image_data)
        image = Image.open(io.BytesIO(image_decoded))
        print("Görüntü başarıyla yüklendi.")
        
        text_list = [text] 
        print(f"İşlenecek metin listesi: {text_list}")
        
        print(f"text_list türü: {type(text_list)}")
        print(f"text_list içeriği: {text_list}")
        
        inputs = processor(text=text, images=image, return_tensors="pt", padding=True)
        print("Girdiler başarıyla işlendi.")
        
        outputs = model(**inputs)
        logits_per_image = outputs.logits_per_image 
        probs = logits_per_image.softmax(dim=1)
        print("Tahminler başarıyla hesaplandı.")
        return jsonify(probs.tolist())
    except Exception as e:
        print(f"Hata oluştu: {e}")
        return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
    app.run(host="0.0.0.0",port="5000",debug=True)