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

## Code Overview

This repository also contains MATLAB scripts for data conversion, synchronization, and preprocessing. Below is a brief description of the available scripts:

### 1. **Data Format Conversion**
- **Behavioral Data (BEH)**: 
    - `[BEH\step0_crt2ren.m]` - Extracts required variables from the raw behavioral data and renames them according to the study specifications.
  
- **Eye-Tracking Data (EYE)**: 
    - `[EYE\step0_asc2mat.m]` - Converts eye-tracking data from `.asc` format to `.mat` format and extracts eye movement events (fixations, saccades, blinks).

- **EEG Data (EEG)**: 
    - `[EEG\step0_cur2set.m]` - Converts EEG data from `.cdt` format to EEGLAB's `.set` format for further processing.

- **NIRS Data (NIR)**: 
    - `[NIR\step0_csv2nir.m]` - Converts near-infrared spectroscopy (NIRS) data from `.csv` format to `.nirs` format.

### 2. **All Multimodal Data Synchronization**
- `[ALL\step0_all2blk.m]` - Synchronizes the sampling times of all modalities based on the event markers from the EEG data.

### 3. **Data Preprocessing**
- **Behavioral Data (BEH)**: 
    - `[BEH\step1_blk2cal.m]` - Calculates joystick angles at the time of button press and computes deviation angles.
  
- **Eye-Tracking Data (EYE)**: 
    - `[EYE\step1_blk2fix.m]` - Removes duplicate data samples.
    - `[EYE\step2_fix2evt.m]` - Extracts eye-tracking events (fixations, saccades, blinks).

- **EEG Data (EEG)**: 
    - `[EEG\step1_blk2int.m]` - Detects bad channels and repairs using interpolation.
    - `[EEG\step2_int2flt.m]` - Applies high-pass and low-pass filters to the EEG data.
    - `[EEG\step3_flt2ica.m]` - Performs Independent Component Analysis (ICA) to decompose EEG signals.
    - `[EEG\step4_ica2lab.m]` - Uses ICLabel to classify and sort ICA components.
    - `[EEG\step5_lab2rme.m]` - Removes EMG and EOG components based on thresholds.

- **NIRS Data (NIR)**: 
    - `[NIR\step1_blk2chk.m]` - Checks and flags bad NIRS channels.
    - `[NIR\step2_chk2pre.m]` - Preprocesses NIRS data including light signal conversion and motion correction.
    - `[NIR\step3_pre2int.m]` - Attempts to repair bad channels using interpolation.

- **EKG Data (EKG)**: 
    - `[EKG\step1_blk2ekg.m]` - Extracts the EKG channel from the raw EEG data.
    - `[EKG\step2_ekg2flt.m]` - Applies high-pass and low-pass filters to the EKG data.
    - `[EKG\step3_flt2pat.m]` - Segments the EKG data into rest and task states.

## Data Overview

The dataset includes raw and preprocessed data for behavior, eye movement, EEG, fNIRS, and EKG modalities. Below is a detailed description of the data format for each modality.

### Behavioral Data (BEH)
- **Raw Data**: 
  - [BEH\RAW.zip] - Raw behavioral data automatically collected by the joystick control program.
- **Preprocessed Data**:
  - [BEH\PRE.zip] - Contains a `BEH` variable consisting of 172 trials (rows) and 6 blocks (columns). The fields are as follows:
    - `Tag`: Target position
    - `Rt1`: Reaction time
    - `Rt2`: Movement time
    - `Rt3`: Response time
    - `MvX`: X coordinate
    - `MvY`: Y coordinate
    - `Dst`: Distance of movement
    - `The`: Orientation angle
    - `tTh`: Mean orientation angle
    - `dTh`: Deviation from mean orientation angle
    - `Acc`: Accuracy

### Eye Movement Data (EYE)
- **Raw Data**:
  - [EYE\RAW.zip] - EDF format files generated by the EyeLink 1000 eye tracker. These can be converted to ASCII (.asc) using the [EDF2ASC tool](https://www.sr-research.com/support/thread-7674.html).
- **Preprocessed Data**:
  - [EYE\PRE.zip] - Contains an `EYE` variable consisting of 172 trials (rows) and 6 blocks (columns). The fields are as follows:
    - `Fix`: Fixations - start time, end time, duration, averaged gaze X, averaged gaze Y, averaged pupil size
    - `Sac`: Saccades - start time, end time, duration, start position X, start position Y, end position X, end position Y, amplitude, peak velocity
    - `Bli`: Blinks - start time, end time, duration
    - `Tag`: Target position 1~6
  - **Note**: The number of rows represents the number of eye movement events detected in each trial. If the number of rows is 0 or empty, no valid events were detected in the time window.

### EEG Data (EEG)
- **Raw Data**:
  - [EEG\RAW.zip] - EEG data recorded using a SynAmps2 amplifier and processed with Curry 8.0.
- **Preprocessed Data**:
  - [EEG\PRE.zip] - Divided into files with suffixes "_rst" (resting state) and "_tsk" (task state). 
    - `EEG_BAD`: Labels bad channels (1 for abnormal, 0 for normal).
    - Data is composed of 6 blocks of EEGLAB data structures.

### fNIRS Data (NIR)
- **Raw Data**:
  - [NIR\RAW.zip] - Original data recorded by ETG-4000, split into two probes with suffixes "_P1" and "_P2".
- **Preprocessed Data**:
  - [NIR\PRE.zip] - Preprocessed data divided into files with suffixes "_rst" (resting state) and "_tsk" (task state).
    - `NIR_BAD`: Labels bad channels (1 for abnormal, 0 for normal).
    - `NIR_RST` and `NIR_TSK`: Composed of 6 blocks, where rows represent sampling points and columns represent channel numbers.
    - The fields are as follows:
      - `HbO`: Oxygenated hemoglobin
      - `HbR`: Deoxygenated hemoglobin
      - `HbT`: Total hemoglobin
      - `Evt`: Event type

### EKG Data (EKG)
- **Raw Data**:
  - [EKG\RAW.zip] - Data divided into "_rst" (resting state) and "_tsk" (task state) files.
    - `EKG_RST` and `EKG_TSK`: Composed of 6 structures, where the number of columns represents the sampling points.
    - The fields are as follows:
      - `data`: Raw waveform
      - `event`: Event list
- **Preprocessed Data**:
  - [EKG\PRE.zip] - Preprocessed data (`EKG_BLK`) is composed of 6 structures, each containing three arrays: `REST`, `SAME`, and `DIFF`, representing resting state, easy task, and hard task, respectively. 
    - The length of the arrays indicates the number of sampling points.

### Handling "NaN" Values
- Certain channels or blocks may contain "NaN" (Not a Number) values due to abnormal data. These errors are handled in the code by ignoring the "NaN" values during calculations.

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

## Data Citation

If you use this dataset in your research, please cite the following:

> Zhang, H., Hu, Y., Li, Y., Zhang, S., & Zhao, C. (2024). Simultaneous dataset of brain, eye, and hand during visuomotor tasks.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or further information, please contact the corresponding author:

**Chenguang Zhao**  
*Email*: [chenguang918.zhao@gmail.com](mailto:chenguang918.zhao@gmail.com)

