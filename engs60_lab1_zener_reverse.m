%% Zener Diode Reverse Characteristics

% Soleil Demick
% ENGS 60 Lab 1

close all; clear; clc

% Import data
data = readtable("data/zener_reverse_1k.csv");
Vr = data.Var2(3:end);
Ir = data.Var3(3:end)*1e-3; % 1V/mA

% % Plot on linear IV plot
fig1 = figure;
hold on; grid on
% data
plot(Vr, Ir, LineWidth=2) 
% Nominal value
scatter(1, 10e-6, ...
    Marker="o", MarkerEdgeColor="k", MarkerFaceColor="k")

% Labels
ax = gca;
ax.FontSize = 16;
legend("Reverse IV Characteristic", "Nominal Value", Location="northwest")
xlabel("\bfReverse Voltage (V)")
ylabel("\bfReverse Leakage Current (A)")
title("\bfZener Diode Reverse Characteristics")
saveas(fig1, "graphics/zener_reverse_linear.png")

% % For comparison to nominal value plot on logy plot
fig2 = figure;
% data
semilogy(Vr, Ir, LineWidth=2)
hold on; grid on
% Average reverse leakage current before breakdown
I_leak = mean(Ir(Vr < 2));
yline(I_leak, "--", sprintf("I_{leak} = %f uA", I_leak*1e6), ...
    LineWidth=2, FontSize=16, LabelHorizontalAlignment="left")
% Nominal value
scatter(1, 10e-6, ...
    Marker="o", MarkerEdgeColor="k", MarkerFaceColor="k")

% Labels
ax = gca;
ax.FontSize = 16;
legend("Reverse IV Characteristic", "", "Nominal Value", ...
    Location="northwest")
xlabel("\bfReverse Voltage (V)")
ylabel("\bfReverse Leakage Current (A)")
title("\bfZener Diode Reverse Characteristics")
saveas(fig2, "graphics/zener_reverse_log.png")