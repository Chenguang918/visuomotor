# Simultaneous Dataset of Brain, Eye, and Hand during Visuomotor Tasks

## Introduction

This repository contains a comprehensive dataset collected during visuomotor tasks that involve brain, eye, and hand coordination. The data was gathered using simultaneous multimodal recordings of electroencephalography (EEG), functional near-infrared spectroscopy (fNIRS), electrocardiography (EKG), eye movement tracking, and joystick responses. This dataset provides insights into the dynamic interaction between visual inputs and motor outputs, offering an invaluable resource for the exploration of visuomotor systems.

## Dataset Overview

### Key Features:
- **Multimodal Data**: Includes EEG (34 electrodes), fNIRS (44 channels), EKG, eye movements, and joystick movements.
- **Visuomotor Tasks**: Tasks with varying difficulty levels (easy and hard) designed to test visuomotor integration.
- **Sample Size**: Data from 50 healthy participants (32 males, 18 females).
- **High Temporal and Spatial Resolution**: EEG sampled at 500 Hz, fNIRS at 10 Hz, joystick at 50,000 Hz, and eye-tracking at 1,000 Hz.

## Data Structure

The dataset is divided into raw and preprocessed data for each modality:

1. **Behavioral Data**: Includes joystick positions, reaction times, and movement trajectories.
2. **EEG Data**: Provides raw and preprocessed EEG data in `cdt` and `mat` formats, respectively.
3. **fNIRS Data**: Contains oxygenated, deoxygenated, and total hemoglobin concentration data.
4. **Eye-Tracking Data**: Tracks fixations, saccades, and blinks.
5. **EKG Data**: Captures heart rate variability across resting and task states.

For more details on the data structure, refer to the `Data_Records.md` file in the repository.

## Installation and Setup

### Requirements:
- MATLAB R2022a or higher
- EEGLAB for EEG data processing
- Homer3 for fNIRS data processing
- PsychToolbox for behavioral data extraction
- Custom MATLAB functions (included in the `scripts` directory)

### Instructions:
1. Clone the repository:
    ```bash
    git clone https://github.com/Chenguang918/visuomotor.git
    ```
2. Navigate to the project directory:
    ```bash
    cd visuomotor
    ```
3. Install the required MATLAB toolboxes listed above.
4. Run the provided scripts in MATLAB to load and preprocess the data.

## Data Usage

The dataset and scripts can be used to:
- Analyze brain and behavioral coordination during visuomotor tasks.
- Explore temporal and spatial dynamics of brain activity (e.g., EEG N2pc components, fNIRS oxygenation changes).
- Evaluate physiological responses through EKG, joystick performance, and eye-tracking.

## Example Usage

Example scripts are available to help users get started with data analysis. To load the preprocessed EEG data, use the following script:

```matlab
% Load EEG data
load('sub1_EEG_rst.mat');
eegplot(EEG.data, 'srate', EEG.srate);
