%GenFMCWRadarTxMsg.m
%This script is used for generating an FMCW message specifically for the
%single Tx USRP FMCW system.

%DECLARING VARIABLES

%==========================================================================
%Tx message signal parameters
%--------------------------------------------------------------------------
T =1;                  %Tx power
f_start1 = 1000e3; %was 0.1e6 
f_start2 = 1000e3;   %was 0.01e6 to check for Mixing operetion
%f_stop = 2e6;           %Chirp stop frequency
T_chirp = .05e-2;       %Chirp period in seconds-3
%N_delay = 10e3;         %Discrete point delay of pulse
N_pulse = T_chirp*fs;
%Discrete point chirp period
phase1=(135)*(pi/180);
phase2 =0;
%SCRIPT MAIN
%==========================================================================
%Tx message signal generation
%--------------------------------------------------------------------------
fprintf('Generating message signals...\n');
%fprintf('Chirp stop frequency: %.2e(Hz)\n', f_start);
%fprintf('Chirp start frequency: %.2e(Hz)\n', f_stop);
%fprintf('Pulse delay: %.2e(secs)\n',  N_delay/fs);
%fprintf('Pulse width: %.2e(secs)\n', N_pulse/fs);
%k_chirp = (f_stop - f_start)/(N_pulse/fs);      %Chirp slope

chirp_exp_pulse_repeat1 = exp(-1*(1j*(2*pi*(f_start1/fs)*n(1:N) + phase1)));
chirp_exp_pulse_repeat2 = exp(-1*(1j*(2*pi*(f_start2/fs)*n(1:N) + phase2)));
%N_periods1 = floor(N/N_pulse);
%N_periods2 = floor(N/N_pulse);

%chirp_exp_pulse_repeat1 = repmat(chirp_exp_pulse1,1,N_periods1);
%chirp_exp_pulse_repeat2 = repmat(chirp_exp_pulse2,1,N_periods2);


chirp_exp_full1 = T*[chirp_exp_pulse_repeat1 chirp_exp_pulse_repeat1(1:N-length(chirp_exp_pulse_repeat1))];
chirp_exp_full2 = T*[chirp_exp_pulse_repeat2 chirp_exp_pulse_repeat2(1:N-length(chirp_exp_pulse_repeat2))];
x_msg_i1 = real(chirp_exp_full1);     %Vector to hold message in-phase vector
x_msg_q1 = imag(chirp_exp_full1);     %Vector to hold message quadrature vector

x_msg_i2 = real(chirp_exp_full2);     %Vector to hold message in-phase vector
x_msg_q2 = imag(chirp_exp_full2);     %Vector to hold message quadrature vector
