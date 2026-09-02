clc;
clear;
close all;

%% =========================
%% CONNECT ARDUINO
%% =========================

a = arduino('COM5', 'Uno', ...
           'Libraries', {'Servo','Ultrasonic'});

servoMotor = servo(a, 'D9');

ultraSensor = ultrasonic(a, 'D6', 'D7');

%% =========================
%% RADAR SETTINGS
%% =========================

maxRange = 2500;      % mm
dangerRange = 1000;   % mm

%% =========================
%% RADAR FIGURE
%% =========================

figure('Color','black');

pax = polaraxes;

hold(pax,'on');

set(pax,'Color','black');
set(pax,'GridColor',[0 1 0]);
set(pax,'ThetaColor',[0 1 0]);
set(pax,'RColor',[0 1 0]);

thetalim([0 180]);

rlim([0 maxRange]);

rticks([0 500 1000 1500 2000 2500]);

rticklabels({'0','0.5m','1m','1.5m','2m','2.5m'});

title('Ultrasonic Radar','Color',[0 1 0]);

%% =========================
%% SPEED SETTINGS
%% =========================

numSamples  = 3;

servoDelay  = 0.002;

sampleDelay = 0.0002;

angleStep   = 2;

%% =========================
%% RADAR MEMORY
%% =========================

scanDistances = maxRange * ones(1,181);

%% =========================
%% OBJECT MEMORY
%% =========================

objectMemory = maxRange * ones(1,181);

%% Detection time memory

objectTime = zeros(1,181);

%% Red object visible time

objectVisibleTime = 2;   % seconds

%% =========================
%% SWEEP SETTINGS
%% =========================

trailLength = 40;

%% =========================
%% DATA LOGGING
%% =========================

logData = [];

%% Reference distance for RMSE

referenceDistance = 1000;   % mm

%% RMSE storage

measuredDistances = [];

referenceDistances = [];

%% =========================
%% MAIN LOOP
%% =========================

try

while true

    %% ====================================
    %% -------- 0 -> 180 SWEEP -----------
    %% ====================================

    for angle = 0:angleStep:180

        %% Move servo

        writePosition(servoMotor, angle/180);

        pause(servoDelay);

        %% =========================
        %% ULTRASONIC FILTERING
        %% =========================

        totalDistance = 0;

        validCount = 0;

        for i = 1:numSamples

            distance = readDistance(ultraSensor);

            distance_mm = distance * 1000;

            %% Validate reading

            if isfinite(distance_mm) && ...
               distance_mm < maxRange

                totalDistance = totalDistance + distance_mm;

                validCount = validCount + 1;

            end

            pause(sampleDelay);

        end

        %% Moving average filter

        if validCount > 0

            averageDistance = ...
                totalDistance / validCount;

        else

            averageDistance = maxRange;

        end

        %% Save radar memory

        scanDistances(angle + 1) = averageDistance;

        %% =========================
        %% SAVE OBJECT MEMORY
        %% =========================

        if averageDistance <= dangerRange

            objectMemory(angle + 1) = averageDistance;

            objectTime(angle + 1) = now;

        end

        %% =========================
        %% CLEAR RADAR
        %% =========================

        cla(pax);

        hold(pax,'on');

        %% Reapply style

        set(pax,'Color','black');
        set(pax,'GridColor',[0 1 0]);
        set(pax,'ThetaColor',[0 1 0]);
        set(pax,'RColor',[0 1 0]);

        thetalim([0 180]);

        rlim([0 maxRange]);

        rticks([0 500 1000 1500 2000 2500]);

        rticklabels({'0','0.5m','1m','1.5m','2m','2.5m'});

        %% =========================
        %% DRAW GREEN SWEEP TRAIL
        %% =========================

        for t = 0:trailLength

            beamAngle = angle - t;

            if beamAngle >= 0 && beamAngle <= 180

                theta = deg2rad(beamAngle);

                fade = 1 - (t / trailLength);

                r = scanDistances(beamAngle + 1);

                polarplot(pax, ...
                         [theta theta], ...
                         [0 r], ...
                         'Color', [0 fade 0], ...
                         'LineWidth', 4);

            end

        end

        %% =========================
        %% DRAW RED OBJECTS
        %% =========================

        for k = 1:181

            if objectMemory(k) < maxRange

                %% Time elapsed

                elapsedTime = ...
                    (now - objectTime(k)) * 86400;

                %% Keep object visible

                if elapsedTime <= objectVisibleTime

                    thetaObj = deg2rad(k-1);

                    polarplot(pax, ...
                             [thetaObj thetaObj], ...
                             [0 objectMemory(k)], ...
                             'r', ...
                             'LineWidth', 5);

                else

                    %% Remove old object

                    objectMemory(k) = maxRange;

                end

            end

        end

        %% =========================
        %% TITLE
        %% =========================

        title(pax, ...
              sprintf('Radar | Angle: %d° | Distance: %.0f mm', ...
              angle, averageDistance), ...
              'Color',[0 1 0]);

        drawnow limitrate nocallbacks;

        %% =========================
        %% CONSOLE OUTPUT
        %% =========================

        fprintf('Angle = %3d | Distance = %7.2f mm\n', ...
                 angle, averageDistance);

        %% =========================
        %% DATA LOGGING
        %% =========================

        timestamp = datetime('now');

        logData = [logData;
                   angle averageDistance];

        %% =========================
        %% RMSE DATA COLLECTION
        %% =========================

        if averageDistance < maxRange

            measuredDistances = ...
                [measuredDistances averageDistance];

            referenceDistances = ...
                [referenceDistances referenceDistance];

        end

    end

    %% ====================================
    %% -------- 180 -> 0 SWEEP -----------
    %% ====================================

    for angle = 180:-angleStep:0

        %% Move servo

        writePosition(servoMotor, angle/180);

        pause(servoDelay);

        %% =========================
        %% ULTRASONIC FILTERING
        %% =========================

        totalDistance = 0;

        validCount = 0;

        for i = 1:numSamples

            distance = readDistance(ultraSensor);

            distance_mm = distance * 1000;

            %% Validate reading

            if isfinite(distance_mm) && ...
               distance_mm < maxRange

                totalDistance = totalDistance + distance_mm;

                validCount = validCount + 1;

            end

            pause(sampleDelay);

        end

        %% Moving average filter

        if validCount > 0

            averageDistance = ...
                totalDistance / validCount;

        else

            averageDistance = maxRange;

        end

        %% Save radar memory

        scanDistances(angle + 1) = averageDistance;

        %% =========================
        %% SAVE OBJECT MEMORY
        %% =========================

        if averageDistance <= dangerRange

            objectMemory(angle + 1) = averageDistance;

            objectTime(angle + 1) = now;

        end

        %% =========================
        %% CLEAR RADAR
        %% =========================

        cla(pax);

        hold(pax,'on');

        %% Reapply style

        set(pax,'Color','black');
        set(pax,'GridColor',[0 1 0]);
        set(pax,'ThetaColor',[0 1 0]);
        set(pax,'RColor',[0 1 0]);

        thetalim([0 180]);

        rlim([0 maxRange]);

        rticks([0 500 1000 1500 2000 2500]);

        rticklabels({'0','0.5m','1m','1.5m','2m','2.5m'});

        %% =========================
        %% DRAW GREEN SWEEP TRAIL
        %% =========================

        for t = 0:trailLength

            beamAngle = angle + t;

            if beamAngle >= 0 && beamAngle <= 180

                theta = deg2rad(beamAngle);

                fade = 1 - (t / trailLength);

                r = scanDistances(beamAngle + 1);

                polarplot(pax, ...
                         [theta theta], ...
                         [0 r], ...
                         'Color', [0 fade 0], ...
                         'LineWidth', 4);

            end

        end

        %% =========================
        %% DRAW RED OBJECTS
        %% =========================

        for k = 1:181

            if objectMemory(k) < maxRange

                elapsedTime = ...
                    (now - objectTime(k)) * 86400;

                if elapsedTime <= objectVisibleTime

                    thetaObj = deg2rad(k-1);

                    polarplot(pax, ...
                             [thetaObj thetaObj], ...
                             [0 objectMemory(k)], ...
                             'r', ...
                             'LineWidth', 5);

                else

                    objectMemory(k) = maxRange;

                end

            end

        end

        %% =========================
        %% TITLE
        %% =========================

        title(pax, ...
              sprintf('Radar | Angle: %d° | Distance: %.0f mm', ...
              angle, averageDistance), ...
              'Color',[0 1 0]);

        drawnow limitrate nocallbacks;

        %% =========================
        %% CONSOLE OUTPUT
        %% =========================

        fprintf('Angle = %3d | Distance = %7.2f mm\n', ...
                 angle, averageDistance);

        %% =========================
        %% DATA LOGGING
        %% =========================

        timestamp = datetime('now');

        logData = [logData;
                   angle averageDistance];

        %% =========================
        %% RMSE DATA COLLECTION
        %% =========================

        if averageDistance < maxRange

            measuredDistances = ...
                [measuredDistances averageDistance];

            referenceDistances = ...
                [referenceDistances referenceDistance];

        end

    end

end

catch ME

    %% =========================
    %% SAVE CSV FILE
    %% =========================

    writematrix(logData, 'RadarLog.csv');

   

end