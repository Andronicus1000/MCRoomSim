function [rvbTme,frq] = EyringKuttruffReverberationTime(Room,pltOpt)
%
% [rvbTme,frq] = EyringKuttruffReverberationTime(Room,pltOpt)
%
% Calculate the reverberation time of the room described by the 'Room'
% configuration structure using the Eyring-Kuttruff formula.
%
% Input: - Room is a room configuration structure, created using the 
%          'SetupRoom' function.
%
% Output: - rvbTme is the vector of the reverberation times at the
%           frequencies defined in the 'Room' structure.
%         - frq is the vector of these frequencies.
%
% Options: - Set pltOpt to false if you don't want the reverberation time
%            to be plotted. The default value is true.
%
% N.Epain, 2011


% Plot the reverberation time by default
if nargin < 2
    pltOpt = true ;
end

% Surfaces of the room walls
srf = [ Room.Dim(2)*Room.Dim(3)*ones(2,1) ; ...
        Room.Dim(1)*Room.Dim(3)*ones(2,1) ; ...
        Room.Dim(1)*Room.Dim(2)*ones(2,1) ] ;
    
% Total surface
srfTot = sum(srf) ;
    
% Room's volume
vol = prod(Room.Dim) ;
    
% Sabine's absorption coefficient    
alfSab = Room.Absorption.' *  srf / srfTot ;

% Eyring's absorption coefficient
alfEyr = -log(1-alfSab) ;

% Frequency values
frq = Room.Freq(:) ;

% Temperature and humidity
tmp = Room.Temp ;
hum = Room.Humidity ;

% Air absorption term (averaged over octave bands)
airAbs = zeros(length(frq),1) ;
for I = 1 : length(frq)
    frqBnd = linspace(frq(I)/sqrt(2),frq(I)*sqrt(2),100) ;
    airAbs(I) = 10.^(3/20*mean(AirAbsorption(frqBnd,tmp,hum)))-1 ;
end

% Reflection coefficient (energy)
rfl = 1 - Room.Absorption ;

% Average reflexion coefficient
rflAvg = rfl.' *  srf / sum(srf) ;

% Kuttruff's correction term
kut = ((rfl.*(rfl-repmat(rflAvg.',6,1))).'*srf.^2) ...
    ./ (rflAvg*srfTot-rfl.'*srf.^2) ;

% Reverberation time
rvbTme = .161*vol ./ ( alfEyr*srfTot + kut + 4*airAbs*vol ) ;

% Plot the reverberation time
if pltOpt == true
    figure('color','white')
    semilogx(frq,rvbTme,'-o','linewidth',2)
    xlim([frq(1)*2^(-1/3) frq(end)*2^(1/3)])
    title('Eyring-Kuttruff Reverberation Time','fontsize',14) ;
    xlabel('Frequency [Hz]','fontsize',14)
    ylabel('RT60 [s]','fontsize',14)
    set(gca,'YGrid','on')
    set(gca,'Xtick',[],'fontsize',14)
    set(gca,'Xtick',[frq(1)/2;frq;frq(end)*2])
    box on
end
