function Receivers = AddReceiver(Receivers,varargin)
%
%
% Receivers = AddReceiver('FieldName',FieldValue,...)
%
% Generate a structure named 'Receivers' containing setup information for
% receivers used during simulations with MCRoomSim
%
% Receivers = AddReceiver(Receivers,'FieldName',FieldValue,...)
%
% Add another receiver to 'Receivers'. If no fields are passed in then a
% default receiver is created.
%
% DESCRIPTION:
% Sets up receivers for the  multi-channel room simulator. Each receiver
% has various options attached, such as receiver type, position, etc. 
% MCRoomSim can simulate any number of receivers (up to the memory limit of
% your computer).
% Receiver options are contained in a structure with the following fields:
% 
% |-----------|--------------------------------------|--------------------|
% |  Field    |               Field                  |      Field         |
% |   Name    |            Description               |      Values        |
% |           |                                      |     {DefaultValue} |
% |-----------|--------------------------------------|--------------------|
% | Location  | Receiver location in metres [X,Y,Z]  | 3-element array of |
% |           | relative to the origin (corner) of   | real-positive      |
% |           | the room                             | numbers            |
% |           |                                      |          {[4,4,1]} |
% |-----------|--------------------------------------|--------------------|
% |Orientation| Orientation of the receiver          | 3-element array of |
% |           | [yaw,pitch,roll] in degrees          | real-positive      |
% |           | (see remarks below)                  | numbers            |
% |           |                                      |          {[0,0,0]} |
% |-----------|--------------------------------------|--------------------|
% |   Type    | Type of receiver                     | 'bidirectional'    |
% |           | (see remarks below)                  | 'cardioid'         |
% |           |                                      | 'dipole'           |
% |           |                                      | 'hemisphere'       |
% |           |                                      | 'hypercardioid'    |
% |           |                                      | 'omnidirectional'  |
% |           |                                      | 'subcardioid'      |
% |           |                                      | 'supercardioid'    |
% |           |                                      | 'unidirectional'   |
% |           |                                      | 'soundfield'       |
% |           |                                      | 'sphharm'          |
% |           |                                      | 'gain'             |
% |           |                                      | 'impulse'          |
% |           |                                      |                    |
% |           |                                      |{'omnidirectional'} |
% |-----------|--------------------------------------|--------------------|
% |UnCorNoise | Use uncorrelated noise when          | true or false      |
% |           | generating response for each channel |                    | 
% |           | in a multichannel receiver?          |            {false} |
% |-----------|--------------------------------------|--------------------|
% |    ITEMS SPECIFIC TO 'sphharm' TYPE RECEIVERS (IGNORED OTHERWISE)     |
% |-----------|--------------------------------------|--------------------|
% | MaxOrder  | Maximum order for Spherical Harmonic | Any real-positive  |
% |           | expansion.                           | integer            |
% |           |                                      |                {3} |
% |-----------|--------------------------------------|--------------------|
% |Convention | Ambisonic convention used when       | 'N3D'              |
% |           | normalising spherical harmonic       | 'SN3D'             |
% |           | components. Note SN2D is also known  | 'N2D'              |
% |           | as the Furse-Malham convention and   | 'SN2D'             |
% |           | SN3D is the Schmidt Seminormalisation|            {'N3D'} |
% |-----------|--------------------------------------|--------------------|
% | Format2D  | Set true to use 'horizontal'         | true or false      |
% |           | spherical harmonics. Set false for   |                    |
% |           | 3D spherical harmonics.              |            {false} |
% |-----------|--------------------------------------|--------------------|
% | ComplexSH | Set true to use complex spherical    | true or false      |
% |           | harmonics during simulation. Set for |                    |
% |           | false for real spherical harmonics.  |            {false} |
% |-----------|--------------------------------------|--------------------|
% |  NFComp   | Apply near field compensation filter?| true or false      |
% |           | (see remarks below)                  |             {true} |
% |-----------|--------------------------------------|--------------------|
% | NFCLimit  | Near field compensation filter       | Any real number    |
% |           | maximum boost limit (dB)             | >=0                |
% |           | (see remarks below)                  |               {20} |
% |-----------|--------------------------------------|--------------------|
% |ITEMS SPECIFIC TO 'gain' & 'impulse' TYPE RECEIVERS (IGNORED OTHERWISE)|
% |-----------|--------------------------------------|--------------------|
% |    Fs     | Sample rate of receiver's directional| Any real-positive  |
% |           | impulse response.                    | number             |
% |           |                                      |            {48000} |
% |-----------|--------------------------------------|--------------------|
% | Response  | 2D or 3D matrix of directional gains | 2D or 3D matrix of |
% |           | or directional impulse responses.    | real numbers       |
% |           | (see remarks below)                  |               {[]} |
% |-----------|--------------------------------------|--------------------|
% | Direction | 2D matrix of directions at which     | 2D  matrix of real |
% |           | responses are defined for (degrees). | numbers            |
% |           | (see remarks below)                  |               {[]} |
% |-----------|--------------------------------------|--------------------|
%
% AddReceiver generates this structure given some field values.
%
% REMARKS:
% - ('FieldName',FieldValue) pairs can be passed in any order.
% - Orientation:
%   Refer to room coordinate system and angle convention below.
%
%   Room Coordinate System
%   
%                       X
%             X1        ^
%        _______________|
%       |               |           * Z axis increases upwards from origin
%       |               |           * Z0 (floor)   
%       |               |           * Z1 (ceiling)
%    Y1 |               | Y0
%       |               | 
%       |               |
%       |               |
%    Y<-----------------0
%             X0
%
%   Angle Convention
%  
%   Azimuth   : Zero on positive x axis
%               Increasing counter clockwise (towards positive y axis)
%   Elevation : Zero on XY plane
%               Increasing upwards (towards positive z axis)
% - Type:
%   sphharm     * This is a multichannel source with the channels having
%                 the directivity of the spherical harmonic functions up to
%                 a specified order.
%               * Refer to GenSHIndices.m for mapping of spherical
%                 harmonic components to receiver channel.
%   soundfield  * Receiver that models the 'SoundField' 4-channel 
%                 microphone.
%               * A 1st order spherical harmonic receiver with 'SN2D'
%                 convention.
%               * Output channels are: W, X, Y & Z
%   gain        * A custom receiver specified with user defined gains at  
%                 desired directions. 
%               * Can be multichannel.
%               * To use this receiver type, 'Response' and 'Direction'
%                 matrices must also be defined.
%   impulse     * A custom receiver specified with user defined impulse 
%                 responses at desired directions. 
%               * Can be multichannel.
%               * To use this reciever type, 'Fs' must be defined, as well  
%                 as the 'Response' and 'Direction' matrices.
% - NFComp:
%   The Near Field Compensation Filter aims to simulate the curvature of 
%   the wavefront and it's drop in pressure related to the radial distance
%   from the source. The Near Field Compensation filter is only applied to
%   the direct sound, not the reflections. This is because as the wave
%   propagates, the wavefront curvature becomes much more planar.
% - NFCLimit:
%   For increasing orders and lower kr, the Near Field Compensation
%   Filter's magnitude heads toward infinity. This value provides a hard
%   limit on the filter's magnitude. Set this value to 0 dB to have the 
%   filter only influence the phase of the direct sound.
% - Response:
%   Response matrix for custom type receivers (gain or impulse). Depending 
%   on custom receiver type, response matrix is either 2D or 3D and is 
%   indexed by:
%   Gain    = 2D matrix [Direction, Channel Number]
%   Impulse = 3D matrix [Direction, Sample, Channel Number]
% - Direction:
%   2 column matrix specifying the directions at which the custom resposnes
%   are defined. Column 1 is azimuth and column 2 is elevation (both in
%   degrees). The number of rows (directions) in this matrix must match the
%   number of gains/impulse responses specified per channel in the Response
%   matrix.
%
% EXAMPLES:
% - Create a receiver structure and setup a dipole receiver at position
%   [2,3,5] oriented parallel to y axis:
%   Receivers = AddReceiver([],         'Type',        'dipole',   ...
%                                     	'Location',    [2,3,5],    ...
%                                   	'Orientation', [90,0,0]    ...
%                            );
% - Add to an existing group of receivers, a 3 channel omnidirectional  
%   receiver located at position [4,4,2] and oriented parallel to the x  
%   axis. The receiver is defined at 300 directions (az,el) using custom 
%   gains:
%   Receivers = AddReceiver(Receivers,  'Type',         'gain',     ...
%                                     	'Location',     [2,2,2],    ...
%                                      	'Orientation',  [0,0,0],    ...
%                                    	'Response',     ones(300,3),...
%                                       'Direction',    [az el]     ...
%                            );
%
% Copyright 2011, A. Wabnitz and N. Epain 
% Last update: 04/07/2011

%--------------------------------------------------------------------------
%   Default Sensor Setup
%--------------------------------------------------------------------------
% Common
DfltLocation        = [ 4 4 1 ];        
DfltOrientation     = [ 0 0 0 ];          
DfltType            = 'omnidirectional'; 
DfltUnCorNoise      = false;

% sphharm receivers
DfltMaxOrder        = 3;
DfltConvention      = 'N3D';
DfltFormat2D        = false;
DfltComplexSH       = false;
DfltNFComp          = true;    
DfltNFCLimit        = 20; 

% gain & impulse receivers
DfltFs              = 48000;
DfltResponse        = struct('Response',[]);
DfltDirection       = [];

%--------------------------------------------------------------------------
%   Check Number Of Arguments
%--------------------------------------------------------------------------
if exist('Receivers','var') && isstruct(Receivers)
    
    if round(length(varargin)/2)~=length(varargin)/2
        error('Illegal number of arguments') ;
    end
    
elseif exist('Receivers','var') && ischar(Receivers)
    
    if round(nargin/2) ~= nargin/2
        error('Illegal number of arguments') ;
    end
    
    for k=nargin:-1:2
        varargin{k} = varargin{k-1};
    end
    
    varargin{1} = Receivers;
    Receivers = [];
    
elseif nargin==0
    Receivers = [];
end


%--------------------------------------------------------------------------
%   Create structure if no struct passed in or add a new element
%--------------------------------------------------------------------------
if isempty(Receivers)
    n = 1;
    Receivers = struct( 'Location',         DfltLocation,    ...
                        'Orientation',      DfltOrientation, ...
                        'Type',             DfltType,        ...
                        'UnCorNoise',       DfltUnCorNoise,  ...
                        'MaxOrder',         DfltMaxOrder,    ...
                        'Convention',       DfltConvention,  ...
                        'Format2D',         DfltFormat2D,    ...
                        'ComplexSH',        DfltComplexSH,   ...
                        'NFComp',           DfltNFComp,      ...
                        'NFCLimit',         DfltNFCLimit,    ...
                        'Fs',               DfltFs,          ...
                        'Chl',              DfltResponse,    ...
                        'Direction',        DfltDirection);
elseif (isstruct(Receivers) ~= 1)
    error('Receivers must be a struct or empty');
else
    n = numel(Receivers);
    n = n+1;
    Receivers(n).Location    = DfltLocation;
    Receivers(n).Orientation = DfltOrientation;
    Receivers(n).Type        = DfltType;
    Receivers(n).UnCorNoise  = DfltUnCorNoise;
    Receivers(n).MaxOrder    = DfltMaxOrder;
    Receivers(n).Convention  = DfltConvention;
    Receivers(n).Format2D    = DfltFormat2D;
    Receivers(n).ComplexSH   = DfltComplexSH;
    Receivers(n).NFComp      = DfltNFComp;
    Receivers(n).NFCLimit    = DfltNFCLimit;
    Receivers(n).Fs          = DfltFs;
    Receivers(n).Chl         = DfltResponse;
    Receivers(n).Direction   = DfltDirection;
end

%--------------------------------------------------------------------------
%   Check Field Values And Assign To Receivers Structure
%--------------------------------------------------------------------------
RespNum = 0;
SoundField = false;
for I = 1 : 2 : length(varargin)-1
    
    switch varargin{I}
        
        case 'Location'
            
            if ~isreal(varargin{I+1})
                error('Location must have real numbers');
            elseif min(min(varargin{I+1}))<0
                error('All values in Location must be greater than 0');
            elseif (length(varargin{I+1})<3)
                error('Too few elements supplied to Location');
            elseif (length(varargin{I+1})>3)
                error('Too many elements supplied to Location');
            else
                Receivers(n).Location = varargin{I+1};
            end

        case 'Orientation'
            
            if ~isreal(varargin{I+1})
                error('Orientation must have real numbers');
            elseif (length(varargin{I+1})<3)
                error('Too few elements supplied to Orientation');
            elseif (length(varargin{I+1})>3)
                error('Too many elements supplied to Orientation');
            else
                Receivers(n).Orientation = varargin{I+1};
            end
        
        case 'Type'
            if ~ischar(varargin{I+1})
                error('Type must be a string');
            elseif strcmp(varargin{I+1},'soundfield')
                SoundField = true;
            else
                Receivers(n).Type = varargin{I+1};
            end
               
        case {'UnCorNoise' 
              'Format2D' 
              'ComplexSH' 
              'NFComp'}
            
            if (islogical(varargin{I+1}))
                Receivers(n).(varargin{I}) = varargin{I+1};
            else
                error(['Invalid value for ' varargin{I}]);
            end
            
        case 'MaxOrder'
            if ~isreal(varargin{I+1})
                error('MaxOrder must be a real number'); 
            elseif varargin{I+1} < 0
                error('MaxOrder must be greater than or equal to 0');
            else
                Receivers(n).MaxOrder = varargin{I+1};
            end
            
        case 'Convention'
            if max(strcmp(varargin{I+1},{'N3D','SN3D','N2D','SN2D'}))
             	Receivers(n).Convention = varargin{I+1};
            else
                error(['Unknown convention: ' varargin{I+1}]);
            end
            
        case 'NFCLimit'
            if ~isreal(varargin{I+1})
                error('NFCLimit must be a real number'); 
            elseif varargin{I+1} < 0
                error('NFCLimit must be greater than or equal to 0');
            else
                Receivers(n).NFCLimit = varargin{I+1};
            end    
            
        case 'Fs'

            if (~isscalar(varargin{I+1}))
                error('Array passed in for Fs');
            elseif ~isreal(varargin{I+1})
                error('Fs must be a real number');
            elseif (varargin{I+1}<=0)
                error('Fs must be greater than 0');
            else
                Receivers(n).Fs = varargin{I+1};
            end
            
        case 'Response'
            
            RespNum = I;
            
        case 'Direction'
            
            if ~isreal(varargin{I+1})
                error('Direction list must have real numbers');
            elseif size(varargin{I+1},2) ~= 2
                error('Direction list must be a 2 column matrix');
            else
                Receivers(n).Direction = varargin{I+1};
            end
                
        otherwise
            
            error([varargin{I} ' is not a recognised options field']) ;
            
    end
end

%--------------------------------------------------------------------------
%   Setup soundfield type receiver if requested
%--------------------------------------------------------------------------
if SoundField
    Receivers(n).Type      = 'sphharm';
    Receivers(n).MaxOrder  = 1;
    Receivers(n).Convention= 'SN2D';
    Receivers(n).Format2D  = false;
    Receivers(n).ComplexSH = false;
end

%--------------------------------------------------------------------------
%   Check Values Are OK And Set Response Matrix (If Needed)
%--------------------------------------------------------------------------
% If custom type receiver is set, then check that response and direction  
% matrices have also been specified and that number of elements match 
% between the two matrices
if (strcmp(Receivers(n).Type,'gain'))
    
    if RespNum==0
        error('Response matrix must be defined for gain type receiver');
    else
        if ~isreal(varargin{RespNum+1})
            error('Custom response must have real numbers');
        elseif length(size(varargin{RespNum+1})) > 2
            error(['Response matrix has too many dimensions. '...
                   'Max is 2 for gain type receivers']);
        else
            nc = size(varargin{RespNum+1},2);
            for ii=1:nc
               Receivers(n).Chl(ii).Response = varargin{RespNum+1}(:,ii);
            end
        end
    
        % Perform more checks on response matrix
        if isempty(Receivers(n).Chl(1).Response)
            error(['Response matrix must be defined for gain type '...
                   'receiver']);
        elseif isempty(Receivers(n).Direction)
            error(['Direction matrix must be defined for gain type '...
                   'receiver']);
        elseif (size(Receivers(n).Direction,1) ~= ...
                size(Receivers(n).Chl(1).Response,1))
            error(['Number of directions in Response matrix does not '...
                   'match number of elements in direction matrix']);
        end
    end
elseif (strcmp(Receivers(n).Type,'impulse'))
    
    if RespNum==0
        error('Response matrix must be defined for impulse type receiver');
    else
        if ~isreal(varargin{RespNum+1})
            error('Custom response must have real numbers');
        elseif length(size(varargin{RespNum+1})) > 3
            error(['Response matrix has too many dimensions. '...
                   'Max is 3 for impulse type receivers']);
        elseif length(size(varargin{RespNum+1})) == 2
            Receivers(n).Chl(1).Response = varargin{RespNum+1}(:,:);
        else
            nc = size(varargin{RespNum+1},3);
            for ii=1:nc
               Receivers(n).Chl(ii).Response = ...
                                    varargin{RespNum+1}(:,:,ii);
            end
        end
    
        % Perform more checks on response matrix
        if isempty(Receivers(n).Chl(1).Response)
            error(['Response matrix must be defined for impulse type '...
                   'receiver']);
        elseif isempty(Receivers(n).Direction)
            error(['Direction matrix must be defined for impusle type '...
                   'receiver']);
        elseif (size(Receivers(n).Direction,1) ~= ...
                size(Receivers(n).Chl(1).Response,1))
            error(['Number of directions in Response matrix does not '...
                   'match number of elements in direction matrix']);
        end
    end
end