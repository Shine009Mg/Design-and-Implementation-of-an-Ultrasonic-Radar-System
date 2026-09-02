clc;
clear;
close all;

%% =========================
%% ACTUAL DISTANCE (REFERENCE)
%% =========================

actual = [100 110 120 130 140 150 160 170 180 190 200];

%% =========================
%% MEASURED DISTANCE
%% =========================

measured = [105.39 113.96 124.13 129.28 ...
            140.87 148.80 160.11 170.64 ...
            180.73 190.24 200.78];

%% =========================
%% RMSE CALCULATION
%% =========================

error = measured - actual;

squaredError = error.^2;

meanSquaredError = mean(squaredError);

RMSE = sqrt(meanSquaredError);

%% =========================
%% DISPLAY RESULTS
%% =========================

fprintf('RMSE = %.3f mm\n', RMSE);

%% =========================
%% PLOT
%% =========================

figure;

plot(actual, measured, ...
    'bo-', ...
    'LineWidth', 2);

hold on;

plot(actual, actual, ...
    'r--', ...
    'LineWidth', 2);

grid on;

xlabel('Actual Distance (mm)');

ylabel('Measured Distance (mm)');

title(['RMSE Analysis | RMSE = ', ...
       num2str(RMSE,'%.3f'), ' mm']);

legend('Measured Data', ...
       'Ideal Reference');

%% =========================
%% ERROR BAR GRAPH
%% =========================

figure;

bar(error);

grid on;

xlabel('Measurement Point');

ylabel('Error (mm)');

title('Measurement Error');