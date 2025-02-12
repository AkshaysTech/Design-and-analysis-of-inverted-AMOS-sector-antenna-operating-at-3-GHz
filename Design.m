% Frequency of operation in GHz
frequency = 3;  % Frequency in GHz
freqHz = frequency * 1e9;

% Frequency range around 3 GHz for S11 and impedance analysis
frequencyRange = (2.2:0.001:3.2) * 1e9;

% Create the inverted Amos sector antenna
antenna = sectorInvertedAmos;

% Display the antenna geometry
figure;
show(antenna);
title('Antenna Geometry(Inverted Amos Sector)');
geometryImg = getframe(gca).cdata;  % Capture the geometry image

% Generate and plot Horizontal (Azimuth) Radiation Pattern at 3 GHz with Elevation = 0°
figure;
pattern(antenna, freqHz, 'Azimuth', 0:1:360, 'Elevation', 0, 'CoordinateSystem', 'polar');
title('Horizontal Radiation Pattern (Azimuth Plane) at 3 GHz');
horizontalImg = getframe(gca).cdata;  % Capture the horizontal pattern image

% Generate and plot Vertical (Elevation) Radiation Pattern at 3 GHz with Azimuth = 0°
figure;
pattern(antenna, freqHz, 'Elevation', -180:1:180, 'Azimuth', 0, 'CoordinateSystem', 'polar');
title('Vertical Radiation Pattern (Elevation Plane) at 3 GHz');
verticalImg = getframe(gca).cdata;  % Capture the vertical pattern image

% Calculate S-parameters over the frequency range
s_params = sparameters(antenna, frequencyRange);

% Plot S11 (Return Loss) over the frequency range
figure;
rfplot(s_params, 1, 1);
title('S11 (Return Loss) vs. Frequency');
xlabel('Frequency (Hz)');
ylabel('S11 (dB)');
grid on;

% Calculate Impedance from S-parameters (using port 1)
impedance = s2z(s_params.Parameters, 50);  % Convert S-parameters to impedance
impedance = squeeze(impedance(1,1,:));     % Extract impedance for port 1

% Plot Impedance vs. Frequency
figure;
plot(frequencyRange / 1e9, real(impedance), '-b', 'DisplayName', 'Real Part');  % Real part
hold on;
plot(frequencyRange / 1e9, imag(impedance), '--r', 'DisplayName', 'Imaginary Part');  % Imaginary part
hold off;
title('Input Impedance vs. Frequency');
xlabel('Frequency (GHz)');
ylabel('Impedance (Ohms)');
legend('show');
grid on;
