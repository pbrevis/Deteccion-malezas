### Detección de malezas con visión computacional

Este repositorio contiene códigos de programación en lenguaje Python y archivos complementarios para discriminar entre plántulas de malezas y cultivo usando visión computacional.

El modelo fue entrenado usando el sistema de detección de objetos "You Only Look Once" (YOLO) versión 8.0 (Jocher et al., 2023). Las fotos de plántulas de maíz y hualcacho (*Echinochloa crusgalli*) provienen del trabajo de Genze et al. (2024) y consistieron en 2.179 imágenes (1.699 para entrenamiento y 480 para validación).

**Referencias**:  
Jocher, G., A. Chaurasia y J. Qiu. 2023. Ultralytics YOLO. Disponible en [github.com/Ultralytics](https://github.com/ultralytics/ultralytics).  
Genze, N., W.K. Vahl, J. Groth, M. Wirth, M. Grieb & D.G. Grimm (2024). Manually annotated and curated Dataset of diverse Weed Species in Maize and Sorghum for Computer Vision. Nature Scientific Data 11:109. Disponible en: [https://doi.org/10.1038/s41597-024-02945-6](https://doi.org/10.1038/s41597-024-02945-6)

![predicted](https://github.com/pbrevis/Deteccion-malezas/blob/main/Fig/val_batch2_pred.jpg)
