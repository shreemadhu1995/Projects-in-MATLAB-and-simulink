%USRP_FMCW_Tx_streaming_main.m
%This is the main script used for USRP Tx streaming during FMCW operations.
%It assumes that a single USRP will be used for Tx operations.

%CLEANUP
%==========================================================================
clear
clc

%DECLARE VARIABLES
%==========================================================================
%USRP parameters
%--------------------------------------------------------------------------
N_loop = 50e3;              %Number of loop iterations for finite Tx transmission option
N_USRP = 1;                 %Number of USRPs used in system
probe_for_USRP = false;     %Flag to determine to initially probe for USRPs
USRP_type = 'B210';         %Type of USRP used for Tx

%Signal Processing parameters
%--------------------------------------------------------------------------
N = 10e3;                  %Number of samples was 100
n = 0 : N-1;                %Discrete sample points
fs = 1e6; 
%Host Tx Sampling rate
show_plots_flag = 1         %flag for whether or not to plot FMCW baseband message

%SCRIPT MAIN
%==========================================================================
disp('Generating FMCW radar baseband message...')
GenFMCWRadarTxMsg                %Generate IQ FMCW Tx data

fprintf('Sampling frequency: %.2e(Hz)\n', fs);
%Save generated FMCW message for future records
disp('Saving Tx FMCW baseband signal...');
save('Tx_FMCW_i.txt', 'x_msg_i1', '-ascii', '-double', '-tabs')
save('Tx_FMCW_q.txt', 'x_msg_q1', '-ascii', '-double', '-tabs')

%Build Tx data to send to Tx USRP object with CH0 being the first column
%and CH1 being the second column.  We are filling in zeros for message sent
%to CH0 and only using CH1.
x_tx_data = [ (x_msg_i1+1j*x_msg_q1)' (x_msg_i2+1j*x_msg_q2)']; 


%Show FMCW baseband signal if show_plots_flag is not zero
if(show_plots_flag)
    figure(11)
    plot(1/fs*n, x_msg_i1)
    title('FMCW Message(In-Phase Component)')
  
    ylabel('Amplitude')
    xlabel('Secs')

    X_MSG_I = fft( x_msg_i1+1j*x_msg_q1);
    figure(4)
    plot(abs(X_MSG_I))
    title('FFT of FMCW message')
end

%Check desired USRP type and instiate appropriate USRP Tx object
if (strcmp(USRP_type,'B210'))
    USRP_Tx_config_and_create_script_B210   %Instantiate X310 USRP Tx object
end

disp('1.Finite transmit and quit')
disp('2.Streaming transmit')
disp('3.EXIT');
choice = input('choice:')

if(choice==1) 
    disp('running one-shot finite transmit')
    USRP_Tx_finite_transmit_dual_channel
elseif(choice==2)
    disp('running streaming transmit')
    USRP_Tx_streaming_transmit_dual_channel
elseif(choice==3)
    disp('exiting...')
else
    
    disp('invalid choice');
    
end
disp('Releasing USRP handler object...');
release(radio_tx);
disp('Script terminated successfully');



