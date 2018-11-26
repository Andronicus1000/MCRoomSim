function Options = MCRoomSimOptions(varargin)
%
%
% Options = MCRoomSimOptions('FieldName',FieldValue,...)
%    
% Generate a structure containing general simulation options for MCRoomSim.
%
% DESCRIPTION:
% The multi-channel room simulator requires a number of options which 
% specify things such as which type(s) of simulations to run, what order,
% thresholds, etc.
% These options are contained in a structure with the following fields:
% 
% |----------|---------------------------------------|--------------------|
% |  Field   |               Field                   |      Field         |
% |   Name   |            Description                |      Values        |
% |          |                                       |     {DefaultValue} |
% |----------|---------------------------------------|--------------------|
% | SimDirect| Simulate direct porition of room      | true or false      |
% |          | impulse response?                     |             {true} |
% |----------|---------------------------------------|--------------------|
% | SimSpec  | Simulate specular reflections?        | true or false      |
% |          |                                       |             {true} |
% |----------|---------------------------------------|--------------------|
% | SimDiff  | Simulate diffuse reflections?         | true or false      |
% |          |                                       |             {true} |
% |----------|---------------------------------------|--------------------|
% |FlipPhase | Invert the phase on every even ordered| true or false      |
% |          | reflection for specular simulation and|                    |
% |          | randomly for diffuse simulation       |             {true} |
% |----------|---------------------------------------|--------------------|
% |AirAbsorp | Simulate air absorption?              | true or false      |
% |          |                                       |             {true} |
% |----------|---------------------------------------|--------------------|
% | Verbose  | Print status messages?                | true or false      |
% |          |                                       |             {true} |
% |----------|---------------------------------------|--------------------|
% |    Fs    | Sampling frequency (Hz)               | Any real-positive  |
% |          | 	                                     | number             |
% |          |                                       |            {48000} |
% |----------|---------------------------------------|--------------------|
% | Duration | Duration of impulse response (sec)    | Any real-positive  |
% |          | (see remarks below)                   | number or -1       |
% |          |                                       |               {-1} |
% |----------|---------------------------------------|--------------------|
% |SoundSpeed| Speed of sound (m/s)                  | Any real-positive  |
% |          | (see remarks below)                   | number or -1       |
% |          |                                       |              {-1}  |
% |----------|---------------------------------------|--------------------|
% |  Order   | Order of specular reflections in      | 3-element array of |
% |          | [X,Y,Z] directions                    | real-positive      |
% |          | (see remarks below)                   | integers or -1     |
% |          |                                       |       {[-1,-1,-1]} |
% |----------|---------------------------------------|--------------------|
% |MinImgSrc | Minimum energy for an image source    | Any real number    |
% |          | (dB, relative to direct sound)        | < 0                |
% |          |                                       |              {-80} |
% |----------|---------------------------------------|--------------------|
% |FineOffset| Set true to correct case when         | true or false      |
% |          | reflection time of arrival falls in   |                    |
% |          | between neighbouring samples. When    |                    |
% |          | false, time of arrival is quantised to|                    | 
% |          | nearest sample position.              |             {true} |
% |----------|---------------------------------------|--------------------|
% | NumRays  | Number of rays to trace from source   | Any real-positive  |
% |          | (see remarks below)                   | integer            |
% |          |                                       |             {2252} |
% |----------|---------------------------------------|--------------------|
% | ReflRate | Number of diffuse reflections per     | Any real-positive  |
% |          | second ariving at receiver            | integer            |
% |          | (see remarks below)                   |            {10000} |
% |----------|---------------------------------------|--------------------|
% | TimeStep | Diffuse simulation time step (sec)    | Any real-positive  |
% |          |                                       | number             |
% |          |                                       |            {0.005} |
% |----------|---------------------------------------|--------------------|
% |MinRayEngy| Ray energy threshold - stop tracing   | Any real number    |
% |          | ray once it goes below this level (dB)| < 0                |
% |          |                                       |             {-120} |
% |----------|---------------------------------------|--------------------|
% | AutoCrop | Automatically remove leading and      | true or false      |
% |          | trailing zeros from response?         |             {true} |
% |----------|---------------------------------------|--------------------|
% |CropThresh| Threshold (dB) used when removing     | Any real number    |
% |          | leading and trailing zeros. Anything  | < 0                |
% |          | below this value will be windowed out |                    |
% |          | from beginning and end of response.   |                    |
% |          | This is relative to the max absolute  |                    |
% |          | value of the room impulse response.   |             {-120} |
% |----------|---------------------------------------|--------------------|
%
% SetupOptionsions generates this structure given some field values.
%
% REMARKS:
% - ('FieldName',FieldValue) pairs can be passed in any order.
% - SoundSpeed:
%   Set this value to -1 to have MCRoomSim calculate it given the 
%   temperature set in the Room Options structure.
% - Duration:
%   Set this value to -1 to have MCRoomSim estimate it given the simulation
%   order, absorption/scattering coefficients, image source threshold and
%   size of the room.
% - Order:
%   Set each value to -1 to have MCRoomSim estimate it given the absorption
%   / scattering coefficients, image source threshold and size of the room. 
%   Combinations can also be set such that orders are estimated only in
%   certain directions, i.e. [-1,10,20] to have MCRoomSim estimate only the
%   X-direction order. Note, values are ignored when Response duration is
%   configured to be estimated for diffuse only simulations 
%   (i.e. Duration=-1, SimSpec=false, SimDiff=true)
% - NumRays, ReflRate:
%   As the volume of the room increases, consider increasing these values
%   in order to smoothen out the impulse response.
%
% EXAMPLES:
% - Setup simulations for specular reflections only, set reflection order
%   for (x,y,z) directions to [10,12,15] and set response duration to be
%   2 seconds:
%   Options = SetupOptionsions('SimSpec',     true,       ...
%                            'Order',       [10,12,15], ...
%                            'SimDiff',     false,      ...
%                            'Duration',    2           ...
%                            );
% - Setup simulations for both specular and diffuse reflections, set
%   response duration and reflection order to be estimated:
%   Options = SetupOptionsions('SimSpec',     true,       ...
%                            'SimDiff',     true,       ...
%                            'Duration',    -1,         ...
%                            'Order',       [-1,-1,-1]  ...
%                            );
%
% Copyright 2011, A. Wabnitz and N. Epain
% Last update: 04/07/2011

%--------------------------------------------------------------------------
%   Default Values For General Options
%--------------------------------------------------------------------------
Options.SimDirect   = true;
Options.Fs          = 48000;                
Options.SoundSpeed  = -1;                
Options.Duration    = -1;                             
Options.FlipPhase   = true;
Options.AirAbsorp   = true;
Options.Verbose     = true;    
Options.AutoCrop    = true;
Options.CropThresh  = -120;

%--------------------------------------------------------------------------
%    Default Values For Specular Simulation Options
%--------------------------------------------------------------------------
Options.SimSpec     = true;                
Options.Order       = [-1 -1 -1];          
Options.MinImgSrc   = -80;                 
Options.FineOffset  = true;               
                                                
%--------------------------------------------------------------------------
%    Default Values For Diffuse Simulation Options
%--------------------------------------------------------------------------
Options.SimDiff     = true;                 
Options.NumRays     = 2252;              
Options.ReflRate    = 10000;              
Options.TimeStep    = 0.005;             
Options.MinRayEngy  = -120;                  

%--------------------------------------------------------------------------
%   Check Number Of Arguments
%--------------------------------------------------------------------------
if round(length(varargin)/2)~=length(varargin)/2
    error('Illegal number of arguments') ;
end

%--------------------------------------------------------------------------
%   Check Field Values And Assign To RoomOpt Structure
%--------------------------------------------------------------------------
for I = 1 : 2 : length(varargin)-1
    
    switch varargin{I}
        
        case 'Fs'

            if (~isscalar(varargin{I+1}))
                error('Array passed in for Fs');
            elseif ~isreal(varargin{I+1})
                error('Fs must be a real number');
            elseif (varargin{I+1}<=0)
                error('Fs must be greater than 0');
            else
                Options.Fs = varargin{I+1};
            end

        case {'SoundSpeed'
        	  'Duration'}
            
            if (~isscalar(varargin{I+1}))
                error(['Array passed in for ' varargin{I}]);
            elseif ~isreal(varargin{I+1})
                error([varargin{I} ' must be a real number']);
            elseif ((varargin{I+1}<=0) && (varargin{I+1}~=-1))
                error([varargin{I} ' must be greater than 0 '...
                       'or -1 (for auto-estimation)']); 
            else
                Options.(varargin{I}) = varargin{I+1};
            end

        case {'SimDirect'
              'FlipPhase'
              'AirAbsorp'
              'Verbose'
        	  'SimSpec'
        	  'FineOffset'
        	  'SimDiff'
        	  'AutoCrop'}
            
            if (islogical(varargin{I+1}))
                Options.(varargin{I}) = varargin{I+1};
            else
                error(['Invalid value for ' varargin{I}]);
            end
            
        case 'Order'
            
            if ~isreal(varargin{I+1})
                error('Order must have real numbers');
            elseif ((min(min(varargin{I+1}))<0) ...
                    && (min(min(varargin{I+1}))~=-1))
                error(['All values in Order must be >= 0'...
                       ' or -1 (for auto-estimation)']);
            elseif (min(varargin{I+1} == round(varargin{I+1}))==0)
                error('All values in Order must be integers');
            elseif (length(varargin{I+1})<3)
                error('Too few elements supplied to Order');
            elseif (length(varargin{I+1})>3)
                error('Too many elements supplied to Order');
            else
                Options.Order = varargin{I+1};
            end
            
        case {'MinImgSrc'
              'MinRayEngy'
              'CropThresh'}
            
            if (~isscalar(varargin{I+1}))
                error(['Array passed in for ' varargin{I}]);
            elseif ~isreal(varargin{I+1})
                error([varargin{I+1} ' must be a real number']);
            elseif (varargin{I+1}>=0)
                error([varargin{I} ' must be less than 0']);
            else
                Options.(varargin{I}) = varargin{I+1};
            end
            
        case {'NumRays'
              'ReflRate'}

            if (~isscalar(varargin{I+1}))
                error(['Array passed in for ' varargin{I}]);
            elseif ~isreal(varargin{I+1})
                error([varargin{I} ' must be a real number']);
            elseif (varargin{I+1}<=0)
                error([varargin{I} ' must be greater than 0']);
            elseif (varargin{I+1} ~= round(varargin{I+1}))
                error([varargin{I} ' must be an integer']);
            else
                Options.(varargin{I}) = varargin{I+1};
            end
        
        case 'TimeStep'
            
            if (~isscalar(varargin{I+1}))
                error('Array passed in for TimeStep');
            elseif ~isreal(varargin{I+1})
                error('TimeStep must be a real number');
            elseif (varargin{I+1}<=0)
                error('TimeStep must be greater than 0');
            else
                Options.TimeStep = varargin{I+1};
            end
            

        otherwise
            
            error([varargin{I} ' is not a recognised options field']) ;
            
    end
end
    
%--------------------------------------------------------------------------
%   Check Values Are OK
%--------------------------------------------------------------------------
% Check that one of specular or diffuse simulation is set
if (~(Options.SimSpec || Options.SimDiff || Options.SimDirect))
    error(['At least one of Direction, Specular or Diffuse simulations '...
           'needs to be set']);
end

if (Options.TimeStep <= (1/Options.Fs))
    error('Diffuse time step is smaller than sampling period');
end

end