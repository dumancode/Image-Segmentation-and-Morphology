# Image Segmentation and Morphology

MATLAB implementation of a classical image segmentation pipeline for dice images. The workflow segments dice regions, detects pips, and counts the number of dots on each die using thresholding and morphological operations.

## Contents

- `dice_segmentation_morphology.m`: main MATLAB function for segmentation and pip counting.
- `dice_sample_01.png` ... `dice_sample_06.png`: input examples.

## Techniques

- RGB to grayscale conversion
- Otsu thresholding with `graythresh`
- Binary segmentation with `imbinarize`
- Morphological closing and opening
- Connected component labeling with `bwlabel`
- Object extraction and pip counting

## Run

Open MATLAB in this folder and run one of the examples:

```matlab
dice_segmentation_morphology('dice_sample_01.png')
```

The function displays intermediate masks and the final segmented dice with detected pip counts.
