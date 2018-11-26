function [SchCur,frq] = SchroederCurve(ImpRsp,smpFrq,bndOpt,pltOpt)
%
% [SchCur,frq] = SchroederCurve(ImpRsp,smpFrq,bndOpt,pltOpt)
%
% Calculate the Schroeder curves from a set of impulse responses.
%
% Input: - ImpRsp is an impulse reponse ([Nx1] vector) or array of impulse
%          responses ([NxM] matrix).
%        - smpFrq is the sampling frequency.
%          This parameter can be omitted, the default value is 48kHz.
%
% Output: - if ImpRsp is a vector, SchCur is the matrix of the Schroeder 
%           (energy decay) curves for different frequency bands. If ImpRsp 
%           is a matrix, SchCur is a 3d array where the third dimension is
%           the frequency band.
%         - frq is the vector of the frequency band center frequencies.
%
% Options: - bndOpt can be set to 'oct' (default) to obtain the curves for 
%            9 octave bands with center frequency from 62.5 to 16kHz, or
%            '3rdoct' in which case the curves are calculated for 25 
%            third-octave bands.
%          - if pltOpt is set to true (default), the Schroeder curves are 
%            plotted.
%
% Note: Requires MATLAB's Signal Processing Toolbox
%
% N.Epain, 2011

% Plot the curves by default
if nargin < 4
    pltOpt = true ;
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

% Length of the impulse responses
nmbSmp = size(ImpRsp,1) ;

% Number of impulse responses
nmbImp = size(ImpRsp,2) ;

% Vector of the center frequencies
switch bndOpt
    case 'oct'
        frq = 1000 * 2.^(-4:4)' ;
    case '3rdoct'
        frq = 1000 * 2.^(-4:1/3:4)' ;
end
nmbFrq = length(frq) ;

% Initialise the output
SchCur = zeros(nmbSmp,nmbImp,nmbFrq) ;

% Loop on the impulse responses
for J = 1 : nmbImp
    
    % Loop on the center frequencies
    for I = 1 : nmbFrq
        
        switch bndOpt
            
            case 'oct'

                % Band-pass filter the current impulse response.
                imp = BandPassFilter(ImpRsp(:,J), ...
                    frq(I)*(2.^[-1/3 0 1/3]),smpFrq,'3rdoct') ;
                
                % Current Schroeder curve
                cur = 10*log10(flipud(cumsum(flipud(sum(imp.^2,2))))) ;
                
            case '3rdoct'
                
                % Band-pass filter the current impulse response.
                imp = BandPassFilter(ImpRsp(:,J),frq(I),smpFrq,'3rdoct') ;
                
                % Current Schroeder curve
                cur = 10*log10(flipud(cumsum(flipud(imp.^2)))) ;
                
        end
        
        % Normalise the Schroeder curve's maximum to 0dB
        SchCur(:,J,I) = cur - max(cur) ;
        
    end
    
end

% Plot the Shroeder curve
if pltOpt == true
    for I = 1 : nmbFrq
        switch bndOpt
            case 'oct'
                subplot(3,3,I), hold on
            case '3rdoct'
                subplot(5,5,I), hold on
        end
        plot((1:length(imp))/(smpFrq),SchCur(:,:,I),'linewidth',2)
        title(['f = ' num2str(round(frq(I))) ' Hz']) ;
        xlabel('Time [s]')
        ylabel('Energy [dB]')
        axis([0 1.05*size(ImpRsp,1)/smpFrq -95 5])
        grid on, box on
    end
end
                
% Format the output
SchCur = squeeze(SchCur) ; 

            
