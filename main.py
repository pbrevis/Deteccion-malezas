# Estas líneas de código fueron ejecutadas en un 'notebook' de Google Colab

### 1. Mounting Google Drive ###
from google.colab import drive
drive.mount('/content/gdrive')

### 2. Define root directory ###
ROOT_DIR = '/content/gdrive/My Drive/weed-detector'

### Install Ultralytics ###
!pip install Ultralytics

from ultralytics import YOLO

model = YOLO("yolov8m.pt")

model.train(data= "/content/gdrive/MyDrive/weed-detector/my-config.yaml", epochs= 30)
