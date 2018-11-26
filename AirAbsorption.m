function A = AirAbsorption(f,T,H,P)
% AIRABSORPTION
%   Computes the frequency dependent air absorption coefficients in dB/m. 
%   Uses ISO 9613-1:1993 standard.
%
%   A = AirAbsorption(f)
%   A = AirAbsorption(f,T)
%   A = AirAbsorption(f,T,H)
%   A = AirAbsorption(f,T,H,P)
%   
%   where   A - Frequency dependent air absorption (dB/m)
%           f - Vector of frequencies (Hz)
%           T - Temperature (Celcius) [Default: 20]
%           H - Relative humidity (0 to 1) [Default: 0.42]
%           P - Atmospheric pressure (kPa) [Default: 101.325]
%
% A. Wabnitz, N. Epain, 2011

% Set defaults
if nargin < 4
    P = 101.325 ;
    if nargin < 3
        H = 0.42 ;
        if nargin < 2
            T = 20 ;
        end
    end
end

% Constants
P0 = 101.325 ;         % Reference pressure (mean sea level, in kPa)
T0 = 293.15 ;          % Reference absolute temperature (in Kelvin)

% Absolute temperature
Ta = T + 273.15 ;

% Relative pressure and temperature
Tr = Ta / T0 ;   
Pr = P  / P0 ;

% Molar concentration of water vapour (%)
h = H * 100 * 10^(4.6151 - 6.8346 * (273.16/Ta)^1.261) / Pr ;

% Oxygen relaxation frequency
frO = Pr * (24 + 4.04e4 * h * (0.02 + h)/(0.391 + h));

% Nitrogen relaxation frequency
frN = Pr * Tr^(-1/2) * (9 + 280 * h * exp(-4.17*(Tr^(-1/3)-1))); 	

% Calculate the air absorption
f2 = f.^2 ;
A = 8.686 * f2 .* ( 1.84e-11 * (1/Pr) * sqrt(Tr) ...
    + Tr^(-5/2) * (  0.01275 * exp(-2239.1/Ta) ./ (frO+f2/frO) ...
    + 0.1068  * exp(-3352/Ta) ./ (frN+f2/frN)  )  ) ;


