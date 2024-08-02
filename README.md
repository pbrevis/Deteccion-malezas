### Detección de malezas con visión computacional

Este repositorio contiene códigos de programación en lenguajes [R](https://github.com/pbrevis/Deteccion-malezas/blob/main/moving-field-weed-dataset.R) y [Python](https://github.com/pbrevis/Deteccion-malezas/blob/main/main.py), y archivos complementarios, para identificar malezas y plantas de maíz usando visión computacional.

El modelo fue entrenado usando el sistema de detección de objetos "You Only Look Once" (YOLO) versión 8.0 (Jocher et al., 2023). Las fotos de plántulas de maíz (*Zea mays*) y hualcacho (*Echinochloa crusgalli*) provienen del trabajo de Genze et al. (2024) y consistieron en 2.179 imágenes (1.699 para entrenamiento y 480 para validación).

**Referencias**:  
Jocher, G., A. Chaurasia y J. Qiu. 2023. Ultralytics YOLO. Disponible en [github.com/Ultralytics](https://github.com/ultralytics/ultralytics).  
Genze, N., W.K. Vahl, J. Groth, M. Wirth, M. Grieb & D.G. Grimm (2024). Manually annotated and curated dataset of diverse weed species in maize and sorghum for computer vision. Nature Scientific Data 11:109. Disponible en: [https://doi.org/10.1038/s41597-024-02945-6](https://doi.org/10.1038/s41597-024-02945-6)

![predicted](https://github.com/pbrevis/Deteccion-malezas/blob/main/Fig/val_batch2_pred.jpg)
![predicted2](https://github.com/pbrevis/Deteccion-malezas/blob/main/Fig/val_batch0_pred.jpg)
