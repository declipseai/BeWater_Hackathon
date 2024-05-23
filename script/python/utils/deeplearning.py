import os
import torch
from torchvision import models, transforms
from PIL import Image
import requests
from io import BytesIO

def convertQuantModel(model_path, data_loader):
    model = torch.jit.load(model_path)
    model.eval()
    
    """
    CONTACT US FOR MORE DETIAL IF NEEDED
    """

    quantized_model = model
    torch.jit.save(torch.jit.script(quantized_model), '/'.join(model_path.split('/')[:-1]) + "/quant_" + model_path.split('/')[-1])

    return model_path

def ensemble_output(outputs):
    """
    Function to compute the ensemble output from multiple model outputs.
    """
    ensemble_output = torch.mean(torch.stack(outputs), dim=0)

    _, predicted = torch.max(ensemble_output, 1)
    confidence = torch.nn.functional.softmax(ensemble_output, dim=1)[0] * 100
    label = get_label(predicted.item())

    return label, confidence, ensemble_output

def preprocess_image(image_path):
    """
    Function to preprocess an image for model input.
    """
    transform = transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ])
    image = Image.open(image_path)
    image = transform(image).unsqueeze(0)
    return image

def load_image_from_url(url):
    """
    Function to load an image from a URL.
    """
    response = requests.get(url)
    image = Image.open(BytesIO(response.content))
    return image

def get_label(index):
    """
    Function to convert class index to label.
    """
    current_file_path = os.path.abspath(__file__)
    with open('/'.join(current_file_path.split('/')[:-1]) + "/imagenet_classes.txt") as f:
        labels = [line.strip() for line in f.readlines()]
    return labels[index]

def classify_image(image, model_path):
    """
    Function to classify an image using a specified model.
    """
    model = torch.jit.load(model_path)
    model.eval()

    with torch.no_grad():
        outputs = model(image)
        _, predicted = torch.max(outputs, 1)
        confidence = torch.nn.functional.softmax(outputs, dim=1)[0] * 100
        label = get_label(predicted.item())
    return label, confidence[predicted[0]].item(), outputs, confidence

# Example usage:
# image_path = "script/python/input_data/car_img.jpg"
# model_path = "script/python/.model_cache/quant_resnet101_jit.pth"

# Preprocess the image
# image = preprocess_image(image_path)

# Classify the image
# label, confidence, raw_res, prob_res = classify_image(preprocess_image(image_path), model_path)
# print(f"Predicted label: {label}, Confidence: {confidence:.2f}% {raw_res.tolist()[0]}")

# Ensemble example
# res = ensemble_output(
#     [torch.tensor([prob_res.tolist()]), torch.tensor([prob_res.tolist()])]
# )
# print(res)
