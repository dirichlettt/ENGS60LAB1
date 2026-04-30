%% Signal Diode Forward Characteristic

% Soleil Demick
% ENGS60 Lab 1

close all; clear; clc

% % Read data
% 1V/mA
data_1VmA = readtable("data/signal_forward_1k.csv");
Vf1 = data_1VmA.Var2(3:end);
% divide V2 by 10^3 to get current from TIA
If1 = data_1VmA.Var3(3:end)*1e-3; 

% 10V/mA on 2V/div
data_10VmA_2Vdiv = readtable("data/signal_forward_10k.csv");
Vf2 = data_10VmA_2Vdiv.Var2(3:end);
% divide V2 by 10^4 to get current from TIA
If2 = data_10VmA_2Vdiv.Var3(3:end)*1e-4; 

% 10V/mA on 100mV/div scale
data_10VmA_100mVdiv = readtable("data/signal_forward_10k_100mV.csv");
Vf3 = data_10VmA_100mVdiv.Var2(3:end);
% divide V2 by 10^5 to get current from TIA
If3 = data_10VmA_100mVdiv.Var3(3:end)*1e-4; 

% % Calculate ideality factor
% visually clip off nonlinear sections of each curve
mask_1 = Vf1 > 0.6;
mask_2 = Vf2 > 0.5;
mask_3 = 0.4 < Vf3 & Vf3 < 0.49;
Vf1_clipped = Vf1(mask_1);
If1_clipped = If1(mask_1);
Vf2_clipped = Vf2(mask_2);
If2_clipped = If2(mask_2);
Vf3_clipped = Vf3(mask_3);
If3_clipped = If3(mask_3);

% combine linear data and fit a line
Vf_signal_linear = [ ...
    Vf1_clipped; Vf2_clipped; Vf3_clipped];
If_signal_linear = log([ ...
    If1_clipped; If2_clipped; If3_clipped]);
[coeffs, err] = polyfit( ...
    Vf_signal_linear, If_signal_linear, 1);

% compute ideality factor
VT = 25.852e-3; % thermal voltage kT/q at 300K
id_fac = 1/(coeffs(1)*VT);

% % Plotting
fig_signal_f = figure;

% plot data
semilogy(Vf1, If1, LineWidth=2)
hold on; grid on
plot(Vf2, If2, LineWidth=2)
plot(Vf3, If3, LineWidth=2)

% plot linear fit
v_lin = [0.2, 0.7];
i_lin = exp(polyval(coeffs, v_lin));
plot( ...
    v_lin, i_lin, ...
    LineWidth=2, LineStyle="--", Color="#6B6666" ...
    )
text(0.3, 1e-6, sprintf("n=%f", id_fac), Fontsize=16)

% labels
legend( ...
    "1V/mA", ...
    "10V/mA @ 2V/div vertical", ...
    "10V/mA @ 0.1V/div vertical", ...
    "Ideality Factor Estimation", ...
    Location="northwest" ...
    )
ax = gca;
ax.FontSize = 16;
ax.XAxis.TickValues = 0:0.1:0.8;
xlabel("\bfForward Voltage (V)", FontSize=16)
ylabel("\bfForward Current (A)", FontSize=16)
title("Signal Diode Forward IV Characteristic")
saveas(fig_signal_f, "graphics/signal_forward_IV.png")