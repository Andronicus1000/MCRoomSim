% RIR = MCRoomSim(SimSetup)
%
%
% MCRoomSim is a multichannel shoebox room simulator used to generate 
% reverberant room impulse responses of any user defined rectangular room.
% 
% In addition to a standard set of source/receiver types (omni, cardioid, 
% dipole, etc.), MCRoomSim is also able to simulate sources/receivers with
% directivity defined by Spherical Harmonic functions (up to a specified
% order) as well user defined directivities. These user defined sources/ 
% receivers can be specified as a series of custom directional gains
% or custom directional impulse responses.
%
% For multichannel receivers such as microphone arrays, MCRoomSim maintains 
% phase information of sound arriving between all channels of the receiver.
%
% 
% For Spherical Harmonic type receivers, MCRoomSim provides the option of
% applying a Near Field Compensation filter to the soundfield.
%
% Many of the key simulation parameters are easily configured using a
% series of MATLAB functions.
% 
% Uses for MCRoomSim include:
%   * Simple echoic simulations to obtain room impulse responses of a room
%     with particular features
%   * Simulation of a speaker array setup in a room by using custom sources 
%     defined with directional impulse responses matching that of the 
%     speakers.
%   * Simulation of arbitrary microphone arrays in an echoic room by using 
%     a multichannel custom receiver with each channel being defined
%     with a series of directional impulse responses matching that of the 
%     individual microphones of the array.
%   * Obtaining the spherical harmonic expansion up to a specified order at 
%     any point within an echoic room using a spherical harmonic type
%     receiver.
%   * Head Related Impulse Responses for an echoic room can be obtained by
%     setting up a 2 channel custom receiver with each channel being
%     defined with the anechoic directional impulse resposnes (HRTFs) for a
%     particular ear.
% 
%
% KEY FEATURES
%   * Fast
%   * Specular and diffuse reflections are simualted
%   * No limit to how many sources/receivers can be simulated in one go
%   * Standard set of source/receiver directivity patterns provided
%   * Can simulate Sources/receivers with directivity defined by Spherical 
%     Harmonic functions
%   * Can simulate sources/receivers defined with custom directivity 
%     patterns or custom directional impulse responses
%   * Can simulate multichannel sources & receivers (no limit on number of
%     channels) 
%   * All settings are configurable using high level functions
%
%
% IF YOU USE THIS SIMULATOR AS PART OF YOUR RESEARCH PLEASE CITE MY PAPER
%
% "Room acoustics simulation for multichannel microphone arrays"
% A. Wabnitz, N. Epain, C. Jin, and A. van Schaik
% in Proceedings of the International Symposium on Room Acoustics
% Melbourne, Australia, August 2010
%
%
% MCRoomSim is a mex function written in C
%
% See also RunMCRoomSim, GenSimSetup, SetupOptions, SetupRoom, Addsource, 
% AddReceiver, PlotSimSetup and GenSHIndices
%
% Copyright 2010, A. Wabnitz and N. Epain
% Last update: 04/07/2011