
clc;
clear;
% Actual distances
actual = [100 110 120 130 140 150];
% Sensor readings while increasing distance
increasing = [103.4 111.65 123.67 130.26 141.49 152.09];
% Sensor readings while decreasing distance
decreasing = [103.4  114.63 122.47  133.34 143.32 152.09 ];
% Hysteresis error
hysteresis_error = abs(increasing - decreasing);
% Maximum hysteresis error
max_hysteresis = max(hysteresis_error);
% Display results
disp('Hysteresis error at each point (mm):');
disp(hysteresis_error);
fprintf('Maximum Hysteresis Error = %.2f mm\n', max_hysteresis);
% Plot
figure;
plot(actual, increasing, 'bo-', 'LineWidth', 2);
hold on;
plot(actual, decreasing, 'rs-', 'LineWidth', 2);
xlabel('Actual Distance (mm)');
ylabel('Measured Distance (mm)');
title('HC-SR04 Hysteresis Test');
legend('Increasing Distance', 'Decreasing Distance');
grid on;




