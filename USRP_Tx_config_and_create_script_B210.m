%USRP_Rx_config_and_create_B210.m
%This script is used to create USRP session handlers and configure them.
%Available USRPs are first detected.  A USRP handler is then created and
%configured.
%This script assumes B210-based USRP model is being used

%DEFINE VARIABLES
%==========================================================================
%Rx USRP parameters
%--------------------------------------------------------------------------
radio_platform = 'B210';            %USRP model being used
radio_serial_num = '30A3E04';       %USRP device serial number

radio_address = '';                 %String to contain USRP IP addresses
tx_ch_mapping = 1 : 2*N_USRP;       %List of channels for Rx USRP system to use
fc = 2.45e9;%*ones(1,1*N_USRP);     %Carrier frequency(vector form)

tx_gain = 40*ones(1,2*N_USRP);       %USRP Rx port gain(vector form)
tx_clock_src = 'Internal';          %Reference clock source for USRP hardware
tx_master_clock_rate = 8e6;        %USRP onboard clock rate
tx_transport_data_type = 'int16';   %Datatype representation of USRP rx samples
%output_data_type = 'single';       %Datatype of output signal
%N_rx_frame = 10e3;                  %Samples per frame of USRP object output
N_tx_frame = 2.5e3;                   %Highest stable samples/frame for 100MHz host fs



%tx_pps_sync_src = 'Internal';       %Source of USRP system PPS sync signal
enable_burst_mode = 0;     

N_burst_frames = 10;               %Highest stable frames/burst for 100MHz host fs and seven USRPs, N_rx_frame = 3e3
N_burst_frames = 16;               %Highest stable frames/burst for 100MHz host fs and eight USRPs, N_rx_frame = 3e3


%---DEBUG---
N_tx_frame = 100;
N_burst_frames = 101;
%---DEBUG---

cfg_timeout = 4;                   %USRP config timeout(in seconds)
%SCRIPT MAIN
%==========================================================================
%Check for connected radios(may not be completely neccessary
if probe_for_USRP
    disp('checking for connected radios...')
    radio_probe = findsdru();
    if strncmp(radio_probe(1).Status, 'Success', 7)
        disp('USRPs detected(assumming B-series USRP)')  
        %radio_found = true;
        %radio_platform = radio_probe(1).Platform;
    else
        error('No radios detected')
    end
end


%Create a single USRP Tx handler for single USB USRP in  Tx system
disp('Generating a single USRP Tx object')
radio_tx = comm.SDRuTransmitter('Platform', radio_platform,...
    'SerialNum', radio_serial_num);



%pause(cfg_timeout);
%Configure USRP Rx handler
disp('Configuring Tx USRP parameters...');
disp('Applying channel mapping...');
radio_tx.ChannelMapping = tx_ch_mapping;
%pause(cfg_timeout);
disp('Applying Tx gain...');
radio_tx.Gain = tx_gain;
disp('Applying clock source...');
radio_tx.ClockSource = tx_clock_src;
disp('Applying master clock rate...');
radio_tx.MasterClockRate = tx_master_clock_rate;
disp('Applying interpolation factor...');
radio_tx.InterpolationFactor = ceil(radio_tx.MasterClockRate/fs);
%disp('Applying output data type...');
radio_tx.TransportDataType = tx_transport_data_type;
%radio_tx.OutputDataType = output_data_type;
% disp('Applying samples per frame...');
% radio_tx.SamplesPerFrame = N_tx_frame;
%disp('Applying PPS source...');
%radio_tx.PPSSource = tx_pps_sync_src;

radio_tx.EnableBurstMode = enable_burst_mode;
if(enable_burst_mode)
   disp('Setting burst mode frame size...');
   radio_tx.NumFramesInBurst = N_burst_frames;   
end



