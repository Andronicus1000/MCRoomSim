function [EDT,frq] = EarlyDecayTime(ImpRsp,smpFrq,bndOpt,pltEDT,pltSchCur)
%
% [EDT,frq] = EarlyDecayTime(ImpRsp,smpFrq,bndOpt,pltRvbTme,pltSchCur) ;
%
% Calculate the Early Decay Times from a set of impulse responses.
%
% Input: - ImpRsp is an impulse reponse ([Nx1] vector) or array of impulse
%          responses ([NxM] matrix).
%        - smpFrq is the sampling frequency.
%          This parameter can be omitted, the default value is 48kHz.
%
% Output: - if ImpRsp is a vector, EDT is the vector of the EDTs for
%           different frequency bands. If ImpRsp is a matrix, EDT is the
%           matrix of the EDTs for each impulse response.
%         - frq is the vector of the frequency band center frequencies.
%
% Options: - bndOpt can be set to 'oct' (default) to obtain the EDTs for 9
%            octave bands with center frequency from 62.5 to 16kHz, or
%            '3rdoct' in which case the EDTs are calculated for 25 
%            third-octave bands.
%          - if pltEDT is set to true (default), the EDTs are plotted.
%          - if pltSchCur is set to true, the Schroeder curves are plotted.
%
% Note: Requires MATLAB's Signal Processing Toolbox
%
% N.Epain, 2011

% Don't plot the Schroeder curve by default
if nargin < 5
    pltSchCur = false ;
end

% Plot the EDTs by default
if nargin < 4
    pltEDT = true ;
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

% Colors used for the reverb time and Schroeder curve plots
clr = lines(nmbImp) ;

% Initialise the output
EDT = zeros(nmbFrq,nmbImp) ;

% Create a new figure for the Schroeder curves
if pltSchCur == true
    figure
end

% Calculate the Schroeder curves
SchCur = SchroederCurve(ImpRsp,smpFrq,bndOpt,false) ;
if nmbImp == 1
    SchCur = permute(SchCur,[1 3 2]) ;
end

% Loop on the impulse responses
for J = 1 : nmbImp
    
    % Loop on the center frequencies
    for I = 1 : nmbFrq
        
        % Estimate the slope of the Schroeder curve between -5 and -35dB
        fst = find(SchCur(:,J,I)>=-1e-2,1,'last') ;
        lst = find(SchCur(:,J,I)<=-10,1,'first') ;
        coe = LinearRegression((fst:lst)'/smpFrq,SchCur(fst:lst,J,I)) ;
        
        % Plot the Shroeder curve 
        if pltSchCur == true
            switch bndOpt
                case 'oct'
                    subplot(3,3,I), hold on
                case '3rdoct'
                    subplot(5,5,I), hold on
            end
            plot((1:nmbSmp)/(smpFrq),SchCur(:,J,I), ...
                'color',clr(J,:),'linewidth',2)
            plot((1:nmbSmp)/(smpFrq), ...
                coe(2)+coe(1)*(1:nmbSmp)/(smpFrq), ...
                'color',clr(J,:))
            title(['f = ' num2str(round(frq(I))) ' Hz']) ;
            xlabel('Time [s]')
            ylabel('Energy [dB]')
            axis([0 1.05*nmbSmp/smpFrq -95 5])
            grid on, box on
        end
        
        % EDT
        EDT(I,J) = -60/coe(1) ;
                
    end
    
end

% Plot the EDTs
if pltEDT == true
    figure('color','white')
    semilogx(frq,EDT,'-o','linewidth',2)
    xlim([frq(1)*2^(-1/3) frq(end)*2^(1/3)])
    title('Early Decay Time (EDT)','fontsize',14) ;
    xlabel('Frequency [Hz]','fontsize',14)
    ylabel('EDT [s]','fontsize',14)
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
    

% Linear regression subroutine
function coe = LinearRegression(tme,eng)
    
    % Number of points to fit
    nmb = length(tme) ;

    % Matrix we need to invert
    Mat = [tme(:) ones(nmb,1)] ;
    
    % Linear coefficients
    coe = pinv(Mat) * eng ;
        

            
