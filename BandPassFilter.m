function SigOut = BandPassFilter(SigInp,frq,smpFrq,bndOpt)
%
% SigOut = BandPassFilter(SigInp,frq,smpFrq,bndOpt) ;
%
% Band-pass filter a set of signals with octave-band or third-octave band
% filters.
%
% Input: - SigInp is a set of signals ([nbSamp x nbChan] array)
%        - frq is the vector of the band-pass filter center frequencies.
%        - smpFrq is the sampling frequency (default value is 48000)
%
% Output: SigOut is the array of the band-pass filtered signals.
%         If nbChan = 1, SigOut is a [nbSamp x nbFreq] matrix.
%         Otherwise, SigOut is a [nbSamp x nbChan x nbFreq] 3D array.
%
% Options: bndOpt can be set to 'oct' (default) or '3rdoct' to filter with 
%          octave-band or third-octave band filters.
%
% Note: Requires MATLAB's Signal Processing Toolbox
%
% N.Epain, 2011

% Default mode: 'oct' for octave band filtering
if nargin < 4
    bndOpt = 'oct' ;
end
bndOpt = lower(bndOpt) ;

% Default sampling frequency: 48kHz
if (nargin<3) || isempty(smpFrq)
    smpFrq = 48e3 ;
end

% Min and max frequencies at which the order 6 and 8 Butterworth filters
% can be used
switch bndOpt
    case 'oct'
        minFrq = smpFrq/200 ;
        maxFrq = smpFrq/8 ;
    case '3rdoct'
        minFrq = smpFrq/80 ;
        maxFrq = smpFrq/8 ;
end

% Number of frequencies
nmbFrq = length(frq) ;

% Number of audio channels
nmbChn = size(SigInp,2) ;

% Signal length
sigLng = size(SigInp,1) ;

% Band-pass filter the signals
SigOut = zeros(sigLng,nmbChn,nmbFrq) ;
for I = 1 : nmbFrq
    
    % Check if the current center frequency is in the minFrq -> maxFrq
    % interval. If not, the signal will be resample.
    if frq(I) < minFrq
        % The frequency is too low, the signal will be downsampled
        rat = [1 2^nextpow2(minFrq/frq(I))] ;
    elseif frq(I) > maxFrq
        % The frequency is too high, the signal will be upsampled
        rat = [2^nextpow2(frq(I)/maxFrq) 1] ;
    else
        % Keep the current smaple frequency
        rat = [1 1] ;
    end
    
    % Band-pass filter for the current frequency
    switch bndOpt
        case 'oct'
            [num,den] = ...
                butter(3,[2^(-1/2) 2^(1/2)]*frq(I)/smpFrq*2*rat(2)/rat(1));
        case '3rdoct'
            [num,den] = ...
                butter(4,[2^(-1/6) 2^(1/6)]*frq(I)/smpFrq*2*rat(2)/rat(1));
    end
    
    % Filter the signals
    for J = 1 : nmbChn
        
        % Current signal
        sig = SigInp(:,J) ;
        
        % Resample the signal
        sig = resample(sig,rat(1),rat(2)) ;
        
        % Filter it
        sig = filter(num,den,sig) ;
        
        % Resample back
        sig = resample(sig,rat(2),rat(1)) ;
        SigOut(:,J,I) = sig(1:sigLng) ;
        
    end
    
end

% Squeeze the output array
% (the output is a matrix if the input signal is one channel only)
SigOut = squeeze(SigOut) ;
