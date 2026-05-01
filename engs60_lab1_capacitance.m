%% Calculate Doping from Capacitance

% Soleil Demick
% ENGS 60 Lab 1

close all; clear; clc

V = [0, 1, 3, 7, 14];
C = [0.87, 0.85, 0.8375, 0.825, 0.8125]*1e-12;
Cinvsq = C.^-2;
[coeffs, err] = polyfit(V, Cinvsq, 1)

% % Estimation of lighter doping
% Constans
q = 1.6e-19; 
eps = 12 * 8.85e-14; % permittivity
A = 1e-4; % don't know what the junction area is, assume 1um^2
N_lighter = 2/(coeffs(1)*q*eps*A^2);
fprintf("Lighter Doping: N_l = %e cm^-3", N_lighter)


figure
hold on; grid on
plot(V, Cinvsq, linewidth=2)
plot(V, polyval(coeffs, V), linewidth=2, LineStyle="--")
text(4, 1.4e24, sprintf("N_l = %1.4e cm^{-3}", N_lighter), Fontsize=16)
ax = gca;
ax.FontSize = 16;
legend("Data", "Lighter Doping Estimation", Location="northwest")
xlabel("\bfReverse Voltage (V)")
ylabel("\bfInverse Capacitance Squared (F^{-2})")
title("\bfDoping Estimation")