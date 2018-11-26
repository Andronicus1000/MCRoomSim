function lm = GenSHIndices(MAXORDER,FORMAT2D)

% function lm = GenSHIndices(MaxOrder,FORMAT2D)
%
% This function generates a 2 column vector representing the source/
% receiver channel ordering to spherical harmonic indices, as used in 
% MCRoomSim.
% The first column is the order (l) and the second is the degree (m).
%
% Inputs:
% MAXORDER is the maximum spherical harmonic expansion order (>=0).
%
% FORMAT2D is true when horizontal spherical harmonics are used and false
% when 3D spherical harmonics are used. Default is false.
%
% Copyright 2010, A. Wabnitz, N. Epain, CARLab & University of Sydney
% Last update: 09/08/2010

if ~isreal(MAXORDER)
    error('MAXORDER must be a real number');
elseif MAXORDER < 0
    error('MAXORDER must be greater than or equal to0');
end

if ~exist('FORMAT2D','var')
    FORMAT2D = false;
end

if FORMAT2D
    lm = zeros(2*MAXORDER+1,2);
    lm(1,:) = [0 0];
    
    idx = 2;
    
    for l=1:MAXORDER
        lm(idx,:) = [l l];
        idx = idx+1;
        lm(idx,:) = [l -l];
        idx = idx+1;
    end
else
    lm = zeros((MAXORDER+1)^2,2);
    
    idx = 1;
    
    for l=0:MAXORDER
        for m=l:-1:1
            lm(idx,:) = [l m];
            idx = idx+1;
            lm(idx,:) = [l -m];
            idx = idx+1;
        end
        
        lm(idx,:) = [l 0];
        idx = idx+1;
    end
end
end