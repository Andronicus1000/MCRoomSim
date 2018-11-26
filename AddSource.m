function Sources = AddSource(Sources,varargin)
%
%
% Sources = AddSource('FieldName',FieldValue,...)
%
% Generate a structure named 'Sources' containing setup information for 
% sources used during simulations with MCRoomSim.
%
% Sources = AddSource(Sources,'FieldName',FieldValue,...)
%
% Add another source to 'Sources'. If no fields are passed in then a
% default source is created.
%
% DESCRIPTION:
% Sets up sources for the  multi-channel room simulator. Each source has
% various options attached, such as source type, position, etc. 
% MCRoomSim can simulate any number of sources (up to the memory limit of
% your computer).
% Source options are contained in a structure with the following fields:
% 
% |-----------|--------------------------------------|--------------------|
% |  Field    |               Field                  |      Field         |
% |   Name    |            Description               |      Values        |
% |           |                                      |     {DefaultValue} |
% |-----------|--------------------------------------|--------------------|
% | Location  | Source location in metres [X,Y,Z]    | 3-element array of |
% |           | relative to the origin (corner) of   | real-positive      |
% |           | the room                             | numbers            |
% |           |                                      |          {[1,1,1]} |
% |-----------|--------------------------------------|--------------------|
% |Orientation| Orientation of the source            | 3-element array of |
% |           | [yaw,pitch,roll] in degrees          | real-positive      |
% |           | (see remarks below)                  | numbers            |
% |           |                                      |          {[0,0,0]} |
% |-----------|--------------------------------------|--------------------|
% |   Type    | Type of source                       | 'bidirectional'    |
% |           | (see remarks below)                  | 'cardioid'         |
% |           |                                      | 'dipole'           |
% |           |                                      | 'hemisphere'       |
% |           |                                      | 'hypercardioid'    |
% |           |                                      | 'omnidirectional'  |
% |           |                                      | 'subcardioid'      |
% |           |                                      | 'supercardioid'    |
% |           |                                      | 'unidirectional'   |
% |           |                                      | 'sphharm'          |
% |           |                                      | 'gain'             |
% |           |                                      | 'impulse'          |
% |           |                                      |                    |
% |           | Additional source types              | 'malespeech'       |
% |           | ('impulse' source presets,           | 'femalespeech'     |
% |           |  see remarks below)                  | 'bandkhats'        |
% |           |                                      | 'soprano'          |
% |           |                                      | 'violin'           |
% |           |                                      | 'viola'            |
% |           |                                      | 'cello'            |
% |           |                                      | 'contrabass'       |
% |           |                                      | 'flute'            |
% |           |                                      | 'oboe'             |
% |           |                                      | 'clarinet'         |
% |           |                                      | 'bassoon'          |
% |           |                                      | 'trumpet'          |
% |           |                                      | 'trombone'         |
% |           |                                      | 'frenchhorn'       |
% |           |                                      | 'tuba'             |
% |           |                                      | 'bassdrum'         |
% |           |                                      | 'tamtam'           |
% |           |                                      | 'cymbals'          |
% |           |                                      | 'timpani'          |
% |           |                                      | 'triangle'         |
% |           |                                      | 'tannoyv6'         |
% |           |                                      |                    |
% |           |                                      |{'omnidirectional'} |
% |-----------|--------------------------------------|--------------------|
% |     ITEMS SPECIFIC TO 'sphharm' TYPE SOURCES (IGNORED OTHERWISE)      |
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
% | ITEMS SPECIFIC TO 'gain' & 'impulse' TYPE SOURCES (IGNORED OTHERWISE) |
% |-----------|--------------------------------------|--------------------|
% |    Fs     | Sample rate of source's directional  | Any real-positive  |
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
% | ITEMS SPECIFIC TO 'impulse' TYPE SOURCE PRESETS (IGNORED OTHERWISE)   |
% |-----------|--------------------------------------|--------------------|
% | RefAngle  | Reference angle for the 'impulse'    | [1x2] vector       |
% |           | source presets.                      | (azm & elv in deg.)|
% |           | (see remarks below)                  |            {[0 0]} |
% |-----------|--------------------------------------|--------------------|
%
% AddSource generates this structure given some field values.
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
%                 harmonic components to source channel.
%   gain        * A custom source specified with user defined gains at 
%                 desired directions. 
%               * Can be multichannel.
%               * To use this source type, 'Response' and 'Direction'  
%                 matrices must also be defined.
%   impulse     * A custom source specified with user defined impulse 
%                 responses at desired directions. 
%               * Can be multichannel.
%               * To use this source type, 'Fs' must be defined, as well as  
%                 the 'Response' and 'Direction' matrices.
%   {preset}    * A number of presets are provided for simulating the
%                 directivity of human voice on musical instruments.
%               * These presets use the 'impulse' source type: when adding
%                 a 'preset' source, a source of the impulse type is added
%                 with a set of directional impulse responses corresponding
%                 to the desired instrument.
%               * The instrument directivity presets have been created
%                 using the data provided by the researchers of the tech.
%                 university of Helsinki (see http://auralization.tkk.fi/)
%               * The human voice directivity presets have been created
%                 from the data provided by the researchers of the National
%                 Research Council of Canada (see Chu et al, "Detailed
%                 Directivity of Sound Fields Around Human Talkers", 2002).
%               * The Tannoy V6 loudspeaker preset has been created using
%                 the directivity data provided by Tannoy.
%               * With the preset sources it is possible to chose the
%                 reference direction. This direction should match the
%                 direction in which the instrument has been recorded.
%
% - Response:
%   Response matrix for custom type sources (gain or impulse). Depending 
%   on custom source type, response matrix is either 2D or 3D and is 
%   indexed by:
%   Gain    = 2D matrix [Direction, Channel Number]
%   Impulse = 3D matrix [Direction, Sample, Channel Number]
% - Direction:
%   2 column matrix specifying the directions at which the custom resposnes
%   are defined. Column 1 is azimuth and column 2 is elevation (both in
%   degrees). The number of rows (directions) in this matrix must match the
%   number of gains/impulse responses specified in the Response matrix.
%
% EXAMPLES:
% - Create a source structure and setup a cardioid source at position
%   [4,6,10] oriented parallel to y axis:
%   Sources = AddSource([],         'Type',        'cardioid', ...
%                                   'Location',    [4,6,10],   ...
%                                   'Orientation', [90,0,0]    ...
%                       );
% - Add to an existing group of sources, an omnidirectional source located
%   at position [2,2,2] and oriented parallel to the x axis. The source is
%   defined at 300 directions (az,el) using custom gains:
%   Sources = AddSource(Sources,    'Type',         'gain',     ...
%                                   'Location',     [2,2,2],    ...
%                                   'Orientation',  [0,0,0],    ...
%                                   'Response',     ones(300,1),...
%                                   'Direction',    [az el]     ...
%                        );
% - Add (to the existing sources) a tuba source. The musician is facing
%   the right wall and MCRoomSim's output impulses will filter some tuba
%   recordings made with a microphone located in direction (+69,+49) deg.,
%   (this corresponds to mic. 5 in the TKK anechoic recordings):
%   Sources = AddSource(Sources,    'Type',         'tuba', ...
%                                   'Location',     [4,6,10], ...
%                                   'Orientation',  [90,0,0],    ...
%                                   'RefAngle',     [69,49] ...
%                       );
%
% Copyright 2011, A. Wabnitz and N. Epain
% Last update: 08/06/2010

%--------------------------------------------------------------------------
%   Default Sensor Setup
%--------------------------------------------------------------------------
% Common
DfltLocation        = [ 1 1 1 ];        
DfltOrientation     = [ 0 0 0 ];          
DfltType            = 'omnidirectional'; 

% sphharm sources
DfltMaxOrder        = 3;
DfltConvention      = 'N3D';
DfltFormat2D        = false;
DfltComplexSH       = false;

% gain & impulse sources
DfltFs              = 48000;
DfltResponse        = struct('Response',[]);
DfltDirection       = [];

% presets
DfltRefAngle        = [0,0];

% Not used for sources
DfltUnCorNoise      = false;    
DfltNFComp          = false;    
DfltNFCLimit        = 0;        

%--------------------------------------------------------------------------
%   Check Number Of Arguments
%--------------------------------------------------------------------------
if exist('Sources','var') && isstruct(Sources)
    
    if round(length(varargin)/2)~=length(varargin)/2
        error('Illegal number of arguments') ;
    end
    
elseif exist('Sources','var') && ischar(Sources)
    
    if round(nargin/2) ~= nargin/2
        error('Illegal number of arguments') ;
    end
    
    for k=nargin:-1:2
        varargin{k} = varargin{k-1};
    end
    
    varargin{1} = Sources;
    Sources = [];
    
elseif nargin==0
    Sources = [];
end


%--------------------------------------------------------------------------
%   Create structure if no struct passed in or add a new element
%--------------------------------------------------------------------------
if isempty(Sources)
    n = 1;
    Sources = struct('Location',      DfltLocation,    ...
                     'Orientation',   DfltOrientation, ...
                     'Type',          DfltType,        ...
                     'UnCorNoise',    DfltUnCorNoise,  ...
                     'MaxOrder',      DfltMaxOrder,    ...
                     'Convention',    DfltConvention,  ...
                     'Format2D',      DfltFormat2D,    ...
                     'ComplexSH',     DfltComplexSH,   ...
                     'NFComp',        DfltNFComp,      ...
                     'NFCLimit',      DfltNFCLimit,    ...
                     'Fs',            DfltFs,          ...
                     'Chl',           DfltResponse,    ...
                     'RefAngle',      DfltRefAngle,    ...
                     'Direction',     DfltDirection);
elseif (isstruct(Sources) ~= 1)
    error('Sources must be a struct or empty');
else
    n = numel(Sources);
    n = n+1;
    Sources(n).Location    = DfltLocation;
    Sources(n).Orientation = DfltOrientation;
    Sources(n).Type        = DfltType;
    Sources(n).UnCorNoise  = DfltUnCorNoise;
    Sources(n).MaxOrder    = DfltMaxOrder;
    Sources(n).Convention  = DfltConvention;
    Sources(n).Format2D    = DfltFormat2D;
    Sources(n).ComplexSH   = DfltComplexSH;
    Sources(n).NFComp      = DfltNFComp;
    Sources(n).NFCLimit    = DfltNFCLimit;
    Sources(n).Fs          = DfltFs;
    Sources(n).Chl         = DfltResponse;
    Sources(n).Direction   = DfltDirection;
    Sources(n).RefAngle    = DfltRefAngle;
end

%--------------------------------------------------------------------------
%   Check Field Values And Assign To Sources Structure
%--------------------------------------------------------------------------
RespNum = 0;
for I = 1 : 2 : length(varargin)-1
    
    switch lower(varargin{I})
        
        case 'location'
            
            if ~isreal(varargin{I+1})
                error('Location must have real numbers');
            elseif min(min(varargin{I+1}))<0
                error('All values in Location must be greater than 0');
            elseif (length(varargin{I+1})<3)
                error('Too few elements supplied to Location');
            elseif (length(varargin{I+1})>3)
                error('Too many elements supplied to Location');
            else
                Sources(n).Location = varargin{I+1};
            end

        case 'orientation'
            
            if ~isreal(varargin{I+1})
                error('Orientation must have real numbers');
            elseif (length(varargin{I+1})<3)
                error('Too few elements supplied to Orientation');
            elseif (length(varargin{I+1})>3)
                error('Too many elements supplied to Orientation');
            else
                Sources(n).Orientation = varargin{I+1};
            end
        
        case 'type'
            if ~ischar(varargin{I+1})
                error('Type must be a string');
            else
                Sources(n).Type = varargin{I+1};
            end
            
        case 'maxorder'
            if ~isreal(varargin{I+1})
                error('MaxOrder must be a real number'); 
            elseif varargin{I+1} < 0
                error('MaxOrder must be greater than or equal to 0');
            else
                Sources(n).MaxOrder = varargin{I+1};
            end
            
        case 'convention'
            if max(strcmp(varargin{I+1},{'N3D','SN3D','N2D','SN2D'}))
             	Sources(n).Convention = varargin{I+1};
            else
                error(['Unknown convention: ' varargin{I+1}]);
            end
            
        case {'format2d'
              'complexsh'}
            
            if (islogical(varargin{I+1}))
                Sources(n).(varargin{I}) = varargin{I+1};
            else
                error(['Invalid value for ' varargin{I}]);
            end
                      
        case 'fs'

            if (~isscalar(varargin{I+1}))
                error('Array passed in for Fs');
            elseif ~isreal(varargin{I+1})
                error('Fs must be a real number');
            elseif (varargin{I+1}<=0)
                error('Fs must be greater than 0');
            else
                Sources(n).Fs = varargin{I+1};
            end
            
        case 'response'
            
            RespNum = I;
            
        case 'direction'
            
            if ~isreal(varargin{I+1})
                error('Direction list must have real numbers');
            elseif size(varargin{I+1},2) ~= 2
                error('Direction list must be a 2 column matrix');
            else
                Sources(n).Direction = varargin{I+1};
            end
                
        case 'refangle'
            
            if ~isreal(varargin{I+1})
                error('Reference angle must be real');
            elseif ~all(size(varargin{I+1})==[1,2])
                error('Reference angle must be a 1x2 raw matrix');
            else
                Sources(n).RefAngle = varargin{I+1};
            end
            
        otherwise
            
            error([varargin{I} ' is not a recognised options field']) ;
            
    end
end
    
%--------------------------------------------------------------------------
%   Check Values Are OK And Set Response Matrix (If Needed)
%--------------------------------------------------------------------------
% If custom type source is set, then check that response and direction  
% matrices have also been specified and that number of elements match 
% between the two matrices
if (strcmpi(Sources(n).Type,'gain'))
    
    if RespNum==0
        error('Response matrix must be defined for gain type source');
    else
        if ~isreal(varargin{RespNum+1})
            error('Custom response must have real numbers');
        elseif length(size(varargin{RespNum+1})) > 2
            error(['Response matrix has too many dimensions. '...
                   'Max is 2 for gain type sources']);
        else
            nc = size(varargin{RespNum+1},2);
            for ii=1:nc
               Sources(n).Chl(ii).Response = varargin{RespNum+1}(:,ii);
            end
        end 
    
        % Perform more checks on response matrix
        if isempty(Sources(n).Chl(1).Response)
            error('Response matrix must be defined for gain type source');
        elseif isempty(Sources(n).Direction)
            error('Direction matrix must be defined for gain type source');
        elseif (size(Sources(n).Direction,1) ~= ...
                size(Sources(n).Chl(1).Response,1))
            error(['Number of directions in Response matrix does not '...
                   'match number of elements in direction matrix']);
        end
    end
    
elseif (strcmpi(Sources(n).Type,'impulse'))
    
    if RespNum==0
        error('Response matrix must be defined for impulse type source');
    else
        if ~isreal(varargin{RespNum+1})
            error('Custom response must have real numbers');
        elseif length(size(varargin{RespNum+1})) > 3
            error(['Response matrix has too many dimensions. '...
                   'Max is 3 for impulse type sources']);
        elseif length(size(varargin{RespNum+1})) == 2
            Sources(n).Chl(1).Response = varargin{RespNum+1}(:,:);
        else
            nc = size(varargin{RespNum+1},3);
            for ii=1:nc
               Sources(n).Chl(ii).Response = varargin{RespNum+1}(:,:,ii);
            end
        end
    
        % Perform more checks on response matrix
        if isempty(Sources(n).Chl(1).Response)
            error(['Response matrix must be defined for impulse type '...
                    'source']);
        elseif isempty(Sources(n).Direction)
            error(['Direction matrix must be defined for impusle type '...
                   'source']);
        elseif (size(Sources(n).Direction,1) ~= ...
                size(Sources(n).Chl(1).Response,1))
            error(['Number of directions in Response matrix does not ' ...
                    'match number of elements in direction matrix']);
        end
    end
    
elseif any(strcmpi(Sources(n).Type,{'bandkhats','bassdrum','bassoon',...
        'cello', ...
        'clarinet','contrabass','cymbals','femalespeech','flute', ...
        'frenchhorn','malespeech','oboe','soprano','timpani', ...
        'triangle','trombone','trumpet','tuba','viola','violin', ...
        'tannoyv6','bassdrum','tamtam'}))
    
    % Load the directivity data
    eval(['load MCRoomSim_' Sources(n).Type])
    
    % Source type is changed to 'impulse'
    Sources(n).Type = 'impulse' ;
    
    % If a reference angle has been provided, normalise the impulse
    % responses so that the gain is constant and equal to 1 in this direct.
    if ~all(Sources(n).RefAngle==[0,0])
        
        % New reference angle, in radiants
        refAng = Sources(n).RefAngle*pi/180 ;
        
        % Direction list angles, in radiants
        impAng = DirLst*pi/180 ;
        
        % In the list, find the closest direction to the ref angle
        [xyzRef(:,1),xyzRef(:,2),xyzRef(:,3)] = ...
            sph2cart(refAng(1),refAng(2),1) ;
        [xyzImp(:,1),xyzImp(:,2),xyzImp(:,3)] = ...
            sph2cart(impAng(:,1),impAng(:,2),1) ;
        Dst = sqrt(sum((xyzImp-repmat(xyzRef,size(impAng,1),1)).^2,2)) ;
        [minDst,refDir] = min(Dst) ;
        
        % Frequency response magnitudes
        FrqRsp = abs(fft(ImpRsp.')) ;
        
        % Normalise the frequency responses to the reference angle
        FrqRsp = FrqRsp ./ repmat(FrqRsp(:,refDir),1,size(impAng,1)) ;
        
        % Back to the time domain
        ImpRsp = ifft(FrqRsp) ;
        
        % Calculate the minimum phase impulse responses
        for I =  1 : size(impAng,1)
            [tmp,ImpRsp(:,I)] = rceps(ImpRsp(:,I)) ;
        end
        
        % Transpose the impulse response array
        ImpRsp = ImpRsp.' ;
    
    end
    
    % Assign the responses, directions and sampling frequency
    Sources(n).Chl(1).Response = ImpRsp ;
    Sources(n).Direction       = DirLst ;
    Sources(n).Fs              = smpFrq ;

elseif any(strcmpi(Sources(n).Type,{'bidirectional','cardioid', ...
        'dipole','hemisphere','hypercardioid','omnidirectional', ...
        'subcardioid','supercardioid','unidirectional','sphharm'}))
    
    % Do nothing.
    
else
    
    % An unknown source type must have been entered
    error('Unknown source type.') ; 
    
end

