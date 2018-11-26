function [C50,frq] = SpeechClarity(ImpRsp,smpFrq,bndOpt,pltC50)
%
% [EarTme,frq] = SpeechClarity(ImpRsp,smpFrq,bndOpt,pltC50) ;
%
% Calculate the Speech Clarity Index (C50) from a set of impulse responses.
%
% Input: - ImpRsp is an impulse reponse ([Nx1] vector) or array of impulse
%          responses ([NxM] matrix).
%        - smpFrq is the sampling frequency.
%          This parameter can be omitted, the default value is 48kHz.
%
% Output: - if ImpRsp is a vector, C50 is the vector of the C50s for
%           different frequency bands. If ImpRsp is a matrix, C50 is the
%           matrix of the C50s for each impulse response.
%         - frq is the vector of the frequency band center frequencies.
%
% Options: - bndOpt can be set to 'oct' (default) to obtain the C50s for 9
%            octave bands with center frequency from 62.5 to 16kHz, or
%            '3rdoct' in which case the C50s are calculated for 25 
%            third-octave bands.
%          - if pltC50 is set to true (default), the C50s are plotted.
%
% Note: Requires MATLAB's Signal Processing Toolbox
%
% N.Epain, 2011

% Plot the C50s by default
if nargin < 4
    pltC50 = true ;
end

% Default "frequency band option": 'oct'
% (octave bands with center frequencies from 62.5 to 16 kHz)
if nargin < 3
    bndOpt = 'oct' ;
end
bndOpt = lower(bndOpt) ;

% Default sampling frequency: 48kHz
if (nargin<2) || isempty(smpFrq)
    smpFrq = 48e3 ;
end

% Number of impulse responses
nmbImp = size(ImpRsp,2) ;

% Vector of the center frequencies
switch lower(bndOpt)
    case 'oct'
        frq = 1000 * 2.^(-4:4)' ;
    case '3rdoct'
        frq = 1000 * 2.^(-4:1/3:4)' ;
end
nmbFrq = length(frq) ;

% Number of samples corresponding to the first 50 ms
nmbSmp = round(5e-2*smpFrq) ;

% Initialise the output
C50 = zeros(nmbFrq,nmbImp) ;

% Loop on the impulse responses
for J = 1 : nmbImp
    
    % Current impulse response
    curImp = ImpRsp(:,J) ;
    
    % Schroeder curves for the current impulse response
    SchCur = SchroederCurve(curImp,smpFrq,bndOpt,false) ;
    
    % Calculate the C50 for every frequency band
    for I = 1 : size(SchCur,2)
        
        % Find the index corresponding to the first 50 ms
        idx = find(SchCur(:,I)<-.1,1,'first') + nmbSmp ;
        
        % C50 value
        C50(I,J) = (1-10^(SchCur(idx,I)/10)) / 10^(SchCur(idx,I)/10) ;
        
    end

end

% Plot the C50s
if pltC50 == true
    figure('color','white')
    semilogx(frq,10*log10(C50),'-o','linewidth',2)
    xlim([frq(1)*2^(-1/3) frq(end)*2^(1/3)])
    title('Speech Clarity index (C50)','fontsize',14) ;
    xlabel('Frequency [Hz]','fontsize',14)
    ylabel('C50 [dB]','fontsize',14)
    set(gca,'YGrid','on')
    set(gca,'Xtick',[],'fontsize',14)
    switch lower(bndOpt)
        case 'oct'
            set(gca,'Xtick',[frq(1)/2;frq;frq(end)*2])
        case '3rdoct'
            set(gca,'Xtick',[frq(1)/2;frq(1:3:end);frq(end)*2])
    end
    box on
end
    
        

            
