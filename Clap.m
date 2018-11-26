function snd = Clap(ImpRsp,smpFrq)
%
% snd = Clap(ImpRsp,smpFrq) ;
%
% Play a clap convolved with an impulse response.
%
% Input: - ImpRsp is an impulse reponse ([Nx1] vector) or array of impulse
%          responses ([NxM] matrix).
%        - smpFrq is the sampling frequency.
%          This parameter can be omitted, the default value is 48kHz.
%
% Output: - if ImpRsp is a vector, snd is a vector whose elements are a 
%           clap sound convolved with the input impulse response. If ImpRsp
%           is a matrix then snd is the convolution of the clap with the 2
%           first columns of ImpRsp.
%
%
% N.Epain, 2011

% Default sampling frequency
if nargin < 2
    smpFrq = 48000 ;
end

% Load the clap
load MCRoomSim_clap.mat

% Resample the clap if the sampling frequency is not 48kHz
if smpFrq ~= 48000
    clp = resample(clp,smpFrq,48000) ;
end

% Convolve the clap with the impulse response(s)
if size(ImpRsp,2) == 1
    snd = fftfilt(ImpRsp,[clp;zeros(size(ImpRsp,1),1)]) ;
else
    snd = fftfilt(ImpRsp(:,1:2),[clp;zeros(size(ImpRsp,1),1)]) ;
end

% Normalise the sound peak level
snd = .99*snd/max(max(abs(snd))) ;

% Play the sound
sound(snd,smpFrq) ;
