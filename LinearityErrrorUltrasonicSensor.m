clc
clear;
close all;
% Actual distance values (mm)
actual = [100 110 120 130 140 150 160 170 180 190 200];
% Measured values from HC-SR04 (mm)
measured = [105.39 113.96 124.13 129.28 140.87 148.8 160.11 170.64 180.73 190.24 200.78] ;
% Best-fit straight line
p = polyfit(actual, measured, 1);
% Predicted values from fitted line
fit_line = polyval(p, actual);
% Linearity error at each point (mm)
linearity_error = measured - fit_line;
% Maximum linearity error (mm)
max_linearity_error = max(abs(linearity_error));
% Display results
fprintf('Linearity Error at each point (mm):\n');
disp(linearity_error);
fprintf('Maximum Linearity Error = %.3f mm\n', max_linearity_error);
% Plot
figure;
plot(actual, measured, 'bo', 'LineWidth', 2);
hold on;
plot(actual, fit_line, 'r-', 'LineWidth', 2);
xlabel('Actual Distance (mm)');
ylabel('Measured Distance (mm)');
title('Linearity Error Analysis');
legend('Measured Data', 'Best-Fit Line');
grid on;