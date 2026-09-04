#  Ultrasonic Radar System with MATLAB Visualization

An ultrasonic radar system developed using **Arduino UNO, HC-SR04 ultrasonic sensor, SG90 servo motor, and MATLAB**. The system measures object distance at different angles and displays the detected objects using a radar-style polar visualization.

<img width="985" height="576" alt="Design and Implementation of an Ultrasonic Radar System with MATLAB Visualization (1)" src="https://github.com/user-attachments/assets/22e7683d-cfad-43ec-98db-7b495a9321c2" />

## Project Overview

This project demonstrates the principles of ultrasonic distance measurement, sensor scanning, data acquisition, calibration, filtering, and real-time visualization.

The HC-SR04 sensor is mounted on a servo motor that scans approximately **0°–180°**. Arduino processes the ultrasonic echo signal and sends the **angle and distance data** to MATLAB through serial communication. MATLAB then visualizes the measurements as a radar-style display.

## Objectives

* Measure the distance of objects using an HC-SR04 ultrasonic sensor.
* Rotate the sensor using an SG90 servo motor.
* Collect and transmit measurement data using Arduino.
* Visualize distance and angle information in MATLAB.
* Apply filtering and calibration to improve measurement performance.
* Analyze measurement accuracy and uncertainty.



## Hardware

| Component        | Function                            |
| ---------------- | ----------------------------------- |
| Arduino UNO      | Main controller and data processing |
| HC-SR04          | Ultrasonic distance measurement     |
| SG90 Servo Motor | Rotates the sensor                  |
| USB Cable        | Serial communication with computer  |

The project uses Arduino UNO as the main controller, HC-SR04 for distance measurement, and a servo motor to scan the environment.

## Software

* **Arduino IDE** – Programming and sensor/servo control
* **MATLAB** – Data processing, visualization, and analysis
* **MATLAB Polar Plot** – Radar-style visualization

Arduino sends formatted **angle + distance** data through serial communication, while MATLAB receives the data and displays it using a polar plot.

## System Workflow

```text
HC-SR04 Ultrasonic Sensor
          ↓
    Trigger / Echo
          ↓
       Arduino
          ↓
   Data Processing
          ↓
 Calibration & Filtering
          ↓
 Serial Communication
          ↓
        MATLAB
          ↓
 Radar Visualization
```

## Measurement Improvement

During testing, small oscillations and unstable measurements were observed due to noise and echo reflections. A **moving average filter** and **sensor calibration** were applied to improve the system performance.

Calibration equation:

```text
Corrected Distance = 1.0411 × Measured Distance − 7.5751
```

##  Experimental Results

| Parameter                |   Result |
| ------------------------ | -------: |
| RMSE                     | ±2.45 mm |
| Accuracy                 |   98.78% |
| Maximum Error            |  5.39 mm |
| Maximum Linearity Error  | 2.917 mm |
| Maximum Hysteresis Error |  3.08 mm |

The experimental data was also logged as a **CSV file using MATLAB** for post-analysis.

## Example Measurement

| Actual Distance (mm) | Measured Distance (mm) |
| -------------------: | ---------------------: |
|                  100 |                 105.39 |
|                  110 |                 113.96 |
|                  120 |                 124.13 |
|                  130 |                 129.28 |
|                  140 |                 140.87 |
|                  150 |                 148.80 |
|                  160 |                 160.11 |
|                  170 |                 170.64 |
|                  180 |                 180.73 |
|                  190 |                 190.24 |
|                  200 |                 200.78 |

## Applications

This project demonstrates concepts that can be applied to:

* Robot obstacle detection
* Autonomous navigation
* Distance measurement systems
* Mobile robotics
* Industrial automation
* Basic sonar/radar visualization

## Project Structure

```text
Ultrasonic-Radar-MATLAB/
│
├── Arduino/
│   └── ultrasonic_radar.ino
│
├── MATLAB/
│   └── ultrasonic_radar.m
│
├── Data/
│   └── measurement_data.csv
│
├── Images/
│   └── system_setup.jpg
│
└── README.md
```

## Skills Demonstrated

**Arduino • MATLAB • Ultrasonic Sensing • Sensor Calibration • Signal Filtering • Serial Communication • Data Logging • Measurement Analysis • Robotics • Automation**

## Team Members

### - Shine Lin Htet
### - Min Aung Thu Hein Htut
### - Arya Pangging

## Project Type

Engineering Measurement Project
**University Project – Robotics and Automation Engineering**

Project Demostration Video
https://youtu.be/GErG-VEEDk4?si=D_1boh0ij2ihYm3_

Project Presentation Video
https://youtu.be/G1-iYFZOoPY?si=_om1KafZ0uyWMa0u
