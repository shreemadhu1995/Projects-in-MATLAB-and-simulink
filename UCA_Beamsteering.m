clear all; clc;
 
%% Simulation parameters
freq = 100e6; % Hz
c = 3e8; % free space speed
lambda = c/freq;
T = 1/freq;
omega = 2*pi*freq;
k = 2*pi/lambda;
N=8;% Number of antenna elements
Ns = 30; % Number of samples per wavelength
ds = lambda/Ns; % Spatial Discretization 
 
Nt = 35; % Number of time samples per period
dt = T/Nt; % Temporal discretization
t = 0:dt:(T); % Duration of simulation: Default is single period
 % Increase the number of periods here for longer simulations
R = (0*lambda):ds:(8*lambda); % Spatial extent
Ntheta = 360; % Number of angular discretization
dtheta = 2*pi/Ntheta;

theta_degree = 0:dtheta:360;
theta = 0:dtheta:(2*pi); % Angular extent of azimuth angle
f1=figure (1); 
clf; 
set(gcf,'Color',[1 1 1]); 
phi=(pi/3);%exitation angle
a= 1.9;
%d = lambda/2;
%delta=(pi/180)*88.8;% delta in degrees,for 60degree steering(delta=k*d*cos(thetanot)) % detla=-k*a*sin(theta)*cos(phizero-phiN)
 A = [2 3 1 4 5 2 6 7]; % Amplitude of each array antenna
 Fa=zeros(1,length(theta));

valueOfdelta = zeros(1,N);
for i=1:(N)
     %phiN=((2*pi*i)/N); angular position of elements,phinot is steering
     %angle exitation 
     delta=-k*a*sin(pi/1)*cos((0)-((2*pi*i)/N)); % delta=-k*a*sin(steerangle(azumith))*cos(phizero-phiN)
     valueOfdelta(i) = delta;
end
 disp(valueOfdelta)
 a=lambda/2;
 for i=0:N-1
     %phiN=((2*pi*i)/N);
     %delta=((pi/180)*(-k*a*sin(theta)*cos((pi/2)-((2*pi*i)/N)))); % detla=-k*a*sin(theta)*cos(phizero-phiN)
 temp = A(i+1) .* exp(1j.*(valueOfdelta(i+1)+(k.*a.*(sin(theta).*cos(phi-(2*pi*i/N))))));
 
 Fa = Fa + temp;
 end
 Fa=abs(Fa);
 figure(1)
 
 kk=polar(theta,Fa/max(Fa)); hold on; axis off
 set(gcf,'Color',[1 1 1]); 
 figure(2)
 
 %plot(theta,Fa/max(Fa))
 %xlabel('Theta in radians')
 %ylabel('Array factor')