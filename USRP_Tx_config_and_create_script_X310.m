%USRP_Tx_config_and_create.m
%This script is used to create USRP session object and configure it.
%Available USRPs are first detected.  A USRP object is then created and
%configured.
%This script assumes X310-based USRP model is being used


%DEFINE VARIABLES
%==========================================================================
%Tx USRP parameters
%--------------------------------------------------------------------------
radio_platform = 'X310';            %USRP model being used
ip_addr_base = '192.168.40.';       %Base IP address for USRPs
radio_address = '';                 %String to contain USRP IP addresses
tx_ch_mapping = 1 : 2*N_USRP;       %List of channels for Rx USRP system to use
fc = 3.5e9*ones(1,1*N_USRP);        %Carrier frequency(vector form)
tx_gain = 20*ones(1,2*N_USRP);      %USRP Rx port gain(vector form)

tx_master_clock_rate = 200e6;       %USRP onboard clock rate for X310 
tx_transport_data_type = 'int16';   %Datatype representation of USRP rx samples
N_tx_frame = 100;                   %Number of samples for each Tx frame sent to USRP
enable_burst_mode = 0;              %Flag for turning on USRP burst mode 
N_burst_frames = 101;               %Highest stable frames/burst for 100MHz host fs and seven USRPs, N_rx_frame = 3e3
N_burst_frames = 16;                %Highest stable frames/burst for 100MHz host fs and eight USRPs, N_rx_frame = 3e3

cfg_timeout = 10;                   %USRP config timeout(in seconds)(used for troubleshooting)

%SCRIPT MAIN
%==========================================================================
% Check for connected radios(may not be completely neccessary
if probe_for_USRP
    disp('checking for connected radios...')
    radio_probe = findsdru();
    if strncmp(radio_probe(1).Status, 'Success', 7)
        disp('USRPs detected(assumming X-series USRP)')  
        %radio_found = true;
        %radio_platform = radio_probe(1).Platform;
    else
        error('No radios detected')
    end
end

%Check if single USRP will be used
if (N_USRP == 1)
    %Single USRP does not necessitate external clocking circuit
    disp('Generating a single USRP Tx object')
    tx_clock_src = 'Internal';          %Reference clock source for USRP hardware set to internal
    tx_pps_sync_src = 'Internal';       %Source of USRP system PPS sync signal set to internal
    radio_address = '192.168.40.3';
end
%Check if multiple USRPs will be used
if (N_USRP > 1)
    disp('Generating a multi USRP Tx object')
    %Create an IP address for each USRP in system
    disp('Generating USRP IP addresses...');
    for cnt = 2 : N_USRP+1
        radio_address = strcat(radio_address,strcat(ip_addr_base, num2str(cnt)));
        if cnt ~= N_USRP+1        
            radio_address = strcat(radio_address, ',');       
        end   
    end
    tx_clock_src = 'External';          %Reference clock source for USRP hardware set to external clocking circuit
    tx_pps_sync_src = 'External';       %Source of USRP system PPS sync signal set to external clocking circuit
end

%Create USRP Tx object
radio_tx = comm.SDRuTransmitter('Platform', radio_platform,...
    'IPAddress', radio_address);

%pause(cfg_timeout);    %configuration timeout(used for troubleshooting)
%Configure USRP USRP Tx object
disp('Configuring Tx USRP parameters...');
disp('Applying channel mapping...');
radio_tx.ChannelMapping = tx_ch_mapping;
%pause(cfg_timeout);    %configuration timeout(used for troubleshooting)
disp('Applying Tx gain...');
radio_tx.Gain = tx_gain;
disp('Applying clock source...');
radio_tx.ClockSource = tx_clock_src;
disp('Applying master clock rate...');
	 = tx_master_clock_rate;
disp('Applying interpolation factor...');
radio_tx.InterpolationFactor = ceil(radio_tx.MasterClockRate/fs);
disp('Applying output data type...');
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
% disp('Applying center frequency...');
% radio_tx.CenterFrequency = fc;
disp('Configured Tx USRP parameters:');
radio_tx