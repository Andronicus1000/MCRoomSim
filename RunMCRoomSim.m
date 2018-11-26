function RIR = RunMCRoomSim(Sources,Receivers,Room,Options)
%
%
% RIR = RunMCRoomSim(Sources,Receivers,Room,Options)
%
% RIR = RunMCRoomSim
% RIR = RunMCRoomSim([],Receivers)
% RIR = RunMCRoomSim(Sources,Receivers)
% RIR = RunMCRoomSim(Sources,Receivers,[],Options)
% etc.
%
% Generate a Room Impulse Response using the MCRoomSim simulator (Multi 
% Channel Room Simulator. RunMCRoomSim collects all the setup data, 
% converts it into a format that MCRoomSim accepts and then runs the 
% simulation.
% 
% If any of the inputs are empty or not passed in, then default settings
% are used.
%
% INPUTS:
%   Sources     - Structure containig the setup parameters of all sources
%                 to be simulated inside MCRoomSim.
%               - Can be an array of structures with each element being
%                 a different source.
%               - Use AddSource function to generate correct structre.
%               - Default settings as in AddSource function.
%
%   Receivers   - Structure containig the setup parameters of all receivers
%                 to be simulated inside MCRoomSim.
%               - Can be an array of structures with each element being
%                 a different receivers.
%               - Use AddReceiver function to generate correct structre.
%               - Default settings as in AddReceiver function.
%
%   Room        - Structure containing the setup parameters of the room
%                 to be used in simulation.
%               - Can only have one RoomOpt struct, i.e. can't be an array.
%               - Use SetupRoom to generate correct structure.
%               - Default settings as in SetupRoom function.
%
%   Options     - Structure containing the setup parameters for general
%                 options in MCRoomSim.
%               - Can only have one GenOpt struct, i.e. can't be an array.
%               - Use SetupGenOptions to generate correct structure.
%               - Default settings as in SetupGenOptions function.
%
% OUTPUT:
%
% Output format depends on how many sources and receivers are present 
% during simulation:
%
% 1  Source/Receiver combination (i.e 1 Receiver & 1 Source)    
%    3D Matrix [SAMPLE, RECEIVER CHANNEL, SOURCE CHANNEL]
%
% 2+ Source/Receiver combinations
%    Cell array indexed as [Receiver Number, Source Number] 
%    Within each cell: 3D Matrix [SAMPLE, RECEIVER CHANNEL, SOURCE CHANNEL]
%
% sphharm type Source/Receiver used
%  	 Refer to GenSHIndices for mapping of spherical harmonic components
% 	 to source/receiver channel
%
%
% See also RunMCRoomSim, GenSimSetup, MCRoomSimOptions, SetupRoom, 
% Addsource, AddReceiver, PlotSimSetup and GenSHIndices
%
% Copyright 2011, A. Wabnitz and N. Epain
% Last update: 04/07/2011

%--------------------------------------------------------------------------
%   Process Input Arguements
%--------------------------------------------------------------------------
% If an input is empty or doesn't exist then default parameters will be
% used

if (exist('Sources','var')~=1) || isempty(Sources)
    Sources     = AddSource();
end

if (exist('Receivers','var')~=1) || isempty(Receivers)
    Receivers   = AddReceiver();
end

if (exist('Room','var')~=1) || isempty(Room)
    Room        = SetupRoom();
end

if (exist('Options','var')~=1) || isempty(Options)
    Options    	= MCRoomSimOptions();
end

%--------------------------------------------------------------------------
%   Convert Setup To A Format That MCRoomSim Accepts
%--------------------------------------------------------------------------

% Source Setup
for I = 1:length(Sources)
    SimSetup.Source(I).Location             = Sources(I).Location;
    SimSetup.Source(I).Orientation          = Sources(I).Orientation;
    SimSetup.Source(I).Type                 = Sources(I).Type;
    SimSetup.Source(I).UncorrNoise          = Sources(I).UnCorNoise;
    SimSetup.Source(I).MaxOrder             = Sources(I).MaxOrder;
    SimSetup.Source(I).Convention           = Sources(I).Convention;
    SimSetup.Source(I).Format2D             = Sources(I).Format2D;
    SimSetup.Source(I).ComplexSH            = Sources(I).ComplexSH;
    SimSetup.Source(I).NearFieldComp        = Sources(I).NFComp;
    SimSetup.Source(I).NFCLimit             = Sources(I).NFCLimit;
    SimSetup.Source(I).Fs                   = Sources(I).Fs;
    SimSetup.Source(I).Direction            = Sources(I).Direction;
    SimSetup.Source(I).Chl                  = Sources(I).Chl;
end

clear Sources

% Receiver Setup
for I = 1:length(Receivers)
    SimSetup.Receiver(I).Location         	= Receivers(I).Location;
    SimSetup.Receiver(I).Orientation    	= Receivers(I).Orientation;
    SimSetup.Receiver(I).Type               = Receivers(I).Type;
    SimSetup.Receiver(I).UncorrNoise        = Receivers(I).UnCorNoise;
    SimSetup.Receiver(I).MaxOrder           = Receivers(I).MaxOrder;
    SimSetup.Receiver(I).Convention         = Receivers(I).Convention;
    SimSetup.Receiver(I).Format2D           = Receivers(I).Format2D;
    SimSetup.Receiver(I).ComplexSH          = Receivers(I).ComplexSH;
    SimSetup.Receiver(I).NearFieldComp      = Receivers(I).NFComp;
    SimSetup.Receiver(I).NFCLimit           = Receivers(I).NFCLimit;
    SimSetup.Receiver(I).Fs                	= Receivers(I).Fs;
    SimSetup.Receiver(I).Direction       	= Receivers(I).Direction;
    SimSetup.Receiver(I).Chl              	= Receivers(I).Chl;
end

clear Receivers

% Room Setup
SimSetup.Room.Dimension                     = Room.Dim;
SimSetup.Room.Humidity                      = Room.Humidity; 
SimSetup.Room.Temperature                   = Room.Temp;
SimSetup.Room.Surface.Frequency             = Room.Freq;
SimSetup.Room.Surface.Absorption            = Room.Absorption;
SimSetup.Room.Surface.Scattering            = Room.Scattering;

clear Room

% General Setup
SimSetup.Options.Fs                         = Options.Fs;
SimSetup.Options.SpeedOfSound               = Options.SoundSpeed;
SimSetup.Options.ResponseDuration           = Options.Duration;
SimSetup.Options.SimulateDirect             = Options.SimDirect;
SimSetup.Options.FlipPhase                  = Options.FlipPhase;
SimSetup.Options.AirAbsorption              = Options.AirAbsorp;
SimSetup.Options.Verbose                    = Options.Verbose;
SimSetup.Options.AutoCrop                   = Options.AutoCrop;
SimSetup.Options.CropThreshold              = Options.CropThresh;
SimSetup.Options.SimulateSpecular           = Options.SimSpec;
SimSetup.Options.ReflectionOrder            = Options.Order;
SimSetup.Options.ImgSrcEnergyThresh         = Options.MinImgSrc;
SimSetup.Options.FineOffset                 = Options.FineOffset;
SimSetup.Options.SimulateDiffuse            = Options.SimDiff;
SimSetup.Options.NumberOfRays               = Options.NumRays;
SimSetup.Options.RateOfReflections          = Options.ReflRate;
SimSetup.Options.DiffuseTimeStep            = Options.TimeStep;
SimSetup.Options.RayEnergyThresh            = Options.MinRayEngy;

clear Options

%--------------------------------------------------------------------------
%   Run Simulation
%--------------------------------------------------------------------------
RIR = MCRoomSim(SimSetup);

end