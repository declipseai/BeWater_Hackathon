import os
import torch
import torch.nn as nn
from torch.utils.data import DataLoader
import torchvision
from torchvision import datasets, transforms
from torchvision.datasets import CIFAR10, ImageNet
from ipfsManager import *

def print_size_of_model(model):
    """
    Function to print the size of the model in megabytes.
    """
    if isinstance(model, torch.jit.RecursiveScriptModule):
        torch.jit.save(model, "temp.p")
    else:
        torch.jit.save(torch.jit.script(model), "temp.p")
    print("Size (MB):", os.path.getsize("temp.p") / 1e6)
    os.remove("temp.p")

def evaluate_model(model, data_loader, device):
    """
    Function to evaluate the accuracy of the model on the provided dataset.
    """
    model.eval()
    correct = 0
    total = 0

    with torch.no_grad():
        for images, labels in data_loader:
            images, labels = images.to(device), labels.to(device)

            outputs = model(images)
            _, predicted = torch.max(outputs, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()

    accuracy = 100 * correct / total
    print(f'Accuracy of the model on the ImageNet validation images: {accuracy:.2f}%')

if __name__ == "__main__":
    num_epochs = 10
    num_train_batches = 20
    num_eval_batches = 20
    eval_batch_size = 32

    normalize = transforms.Normalize(mean=[0.485, 0.456, 0.406],
                                     std=[0.229, 0.224, 0.225])
    transform = transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        normalize,
    ])

    # Define the ImageNet test dataset
    # http://www.image-net.org/ => ILSVRC2012_devkit_t12.tar.gz
    # http://www.image-net.org/ => ILSVRC2012_img_val.tar
    test_dataset = ImageNet(root='dataset_img',
                            split="val",
                           # train=False,
                           # download=True,
                            transform=transform)

    # Define the DataLoader for the test dataset
    test_loader = DataLoader(dataset=test_dataset,
                             batch_size=32,
                             shuffle=False,
                             num_workers=2)

    # Load and evaluate the first model
    model = torch.jit.load(check_and_download_and_return_file('QmQJ5TtJzWU8pfGEWcNPe9KTgvUyGjoJFnHRgZGQFCCrf4'))
    print_size_of_model(model)
    evaluate_model(model, test_loader, device='cpu')

    # Load and evaluate the second model
    model = torch.jit.load(check_and_download_and_return_file('QmfGfrucitqafzs534A1HVUggdaSpM8Kgu9tkfhVvdE1uq'))
    print_size_of_model(model)
    evaluate_model(model, test_loader, device='cpu')