function [rvbTme,frq] = FitzroyKuttruffReverberationTime(Room,pltOpt)
%
% [rvbTme,frq] = FitzroyKuttruffReverberationTime(Room,pltOpt)
%
% Calculate the reverberation time of the room described by the 'Room'
% configuration structure using the Fitzroy-Kuttruff formula. This formula
% is supposed to give slightly better results than the Eyring formula when
% the wall absorptions are uneven (e.g. more absorbant floor and ceiling).
% 
% Ref.: R.O. NEUBAUER, "Estimation of reverberation time in rectangular
% rooms with non-uniformly distributed absortion using a modified Fitzroy
% equation" Building Acoustics 8(2), 2001, pp 115-137.
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

% Frequency values
frq = Room.Freq(:) ;

% Room's volume
vol = prod(Room.Dim) ;
    
% Surfaces of the room walls
srf = [ Room.Dim(2)*Room.Dim(3)*ones(2,1) ; ...
        Room.Dim(1)*Room.Dim(3)*ones(2,1) ; ...
        Room.Dim(1)*Room.Dim(2)*ones(2,1) ] ;
    
% Total surface
srfTot = sum(srf) ;
    
% Total surface for each pair of parallel walls
srfPar = 2*srf(1:2:end) ;

% Sabine's absorption coefficient    
alfSab = Room.Absorption.' *  srf / srfTot ;

% Eyring's absorption coefficient
alfEyr = -log(1-alfSab) ;

% Reflection coefficient (energy)
rfl = 1 - Room.Absorption ;

% Average reflexion coefficient
rflAvg = rfl.' *  srf / sum(srf) ;

% Reflexion coefficient for each pair of parallel walls
rflPar = reshape(mean(reshape(rfl,2,3*length(frq))),3,length(frq)) ;

% Fitzroy-Kuttruff absorption coefficients for each pair of parallel walls
alfPar = repmat(alfEyr.',3,1) + rflPar.*(rflPar-repmat(rflAvg.',3,1)) ...
    .* repmat(srfPar.^2,1,length(frq)) ./ repmat(rflAvg.'*srfTot^2,3,1)  ;

% Neubauer's (Fitzroy-Kuttruff) absorption term
neuAbs = srfTot^2 ./ ( srfPar.' * (1./alfPar) ) ;

% Temperature and humidity
tmp = Room.Temp ;
hum = Room.Humidity ;

% Air absorption term (averaged over octave bands)
airAbs = zeros(length(frq),1) ;
for I = 1 : length(frq)
    frqBnd = linspace(frq(I)/sqrt(2),frq(I)*sqrt(2),100) ;
    airAbs(I) = 10.^(3/20*mean(AirAbsorption(frqBnd,tmp,hum)))-1 ;
end

% Reverberation time
rvbTme = .161*vol ./ ( neuAbs.' + 4*airAbs*vol ) ;

% Plot the reverberation time
if pltOpt == true
    figure('color','white')
    semilogx(frq,rvbTme,'-o','linewidth',2)
    xlim([frq(1)*2^(-1/3) frq(end)*2^(1/3)])
    title('Fitzroy-Kuttruff Reverberation Time','fontsize',14) ;
    xlabel('Frequency [Hz]','fontsize',14)
    ylabel('RT60 [s]','fontsize',14)
    set(gca,'YGrid','on')
    set(gca,'Xtick',[],'fontsize',14)
    set(gca,'Xtick',[frq(1)/2;frq;frq(end)*2])
    box on
end
