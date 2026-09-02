clc;
clear;
close all;

%% Actual distance values (mm)
actual = [100 110 120 130 140 150 160 170 180 190 200];

%% Measured values from HC-SR04 (mm)
measured = [105.39 113.96 124.13 129.28 140.87 ...
            148.8 160.11 170.64 180.73 190.24 200.78];

%% Calibration using best-fit line

% Generate calibration equation
p = polyfit(measured, actual, 1);

% Calibration coefficients
m = p(1);
c = p(2);

%% Display calibration equation

fprintf('Calibration Equation:\n');
fprintf('Corrected Distance = %.4f * Measured + %.4f\n\n', m, c);

%% Apply calibration

corrected = m * measured + c;

%% Best-fit line for calibrated data

fit_line = polyval(polyfit(actual, corrected, 1), actual);

%% Calibration error

calibration_error = corrected - actual;

%% Maximum calibration error

max_error = max(abs(calibration_error));

%% Display results

disp('Calibration Error at each point (mm):');
disp(calibration_error);

fprintf('Maximum Calibration Error = %.3f mm\n', max_error);

%% Plot

figure;

plot(actual, measured, 'bo', 'LineWidth', 2);
hold on;

plot(actual, corrected, 'g*-', 'LineWidth', 2);

plot(actual, fit_line, 'r-', 'LineWidth', 2);

xlabel('Actual Distance (mm)');
ylabel('Distance (mm)');

title('HC-SR04 Calibration Analysis');

legend('Measured Data', ...
       'Calibrated Data', ...
       'Best-Fit Line');

grid on;