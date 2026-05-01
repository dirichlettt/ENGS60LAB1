%% Signal Diode Reverse Characteristics

% Soleil Demick
% ENGS 60 Lab 1

close all; clear; clc

% Read data
data = readtable("data/signal_reverse.csv");
Vr = data.Var2(3:end);
Ir = data.Var3(3:end)*1e-7*1e9; % 100nA/V -> nA

% Clean negative and nan values from data
nanmask = ~(isnan(Vr) | isnan(Ir)); % remove all rows with nan values
posmask = Vr > 0 & Ir > 0; % remove negative values
Vr = Vr(nanmask & posmask);
Ir = Ir(nanmask & posmask);
    
% Assume I = a*V^b, solve for a,b
[powfit, gof] = fit(Vr, Ir, @(a, b, x) a.*x.^b)
powmodel = powfit(sort(Vr));

% % Linear plot
fig1 = figure;
hold on; grid on
% data
plot(Vr, Ir, LineWidth=2) 

% Nominal Leakage Current
yline(25, "--", "I_{leakage} = 25 nA", ...
    LineWidth=2, LabelVerticalAlignment="bottom", FontSize=16)

% Labels
ax = gca;
ax.FontSize = 16;
legend( ...
    "Reverse IV Characteristic", "Nominal Leakage Current", ...
    Location="northwest")
xlabel("\bfReverse Voltage (V)")
ylabel("\bfReverse Leakage Current (nA)")
title("\bfSignal Diode Reverse Characteristics")
saveas(fig1, "graphics/signal_reverse_linear.png")

% % Logy plot
fig2 = figure;
% data
semilogy(Vr, Ir, LineWidth=2)
hold on; grid on
% power model
plot(sort(Vr), powmodel, LineWidth=2, Linestyle="--")

% Nominal Leakage Current
yline(25, "--", "I_{leakage} = 25 nA", ...
    LineWidth=2, LabelVerticalAlignment="bottom", FontSize=16)

% Labels
text(1, 3, sprintf("I_r = %fV_r^{%f}", powfit.a, powfit.b), FontSize=16)
ax = gca;
ax.FontSize = 16;
legend( ...
    "Reverse IV Characteristic", ...
    "Power Model", ...
    "Nominal Leakage Current", ...
    Location="northwest")
xlabel("\bfReverse Voltage (V)")
ylabel("\bfReverse Leakage Current (nA)")
title("\bfSignal Diode Reverse Characteristics")
saveas(fig2, "graphics/signal_reverse_log.png")