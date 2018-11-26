# MCRoomSim
**MultiChannel Room Simulator**  
<sup>This is the new home for MCRoomSim since the original link has died.</sup>

MCRoomSim is a multichannel shoebox room acoustics simulator that enables simulation of multichannel microphone arrays, HRTFs and spherical harmonic expansions in reverberant environments. It operates as an extension function to MATLAB (mex). Please refer to `MCRoomSim.m` for info about the simulator.

Windows users may need to install Microsoft Visual C++ Redistributable Package prior to running. This package is available for download from the Microsoft website.

To configure the simulator use the suite of high level functions:
* `AddSource`: Creates and configures a new source to add to the simulation.
* `AddReceiver`: Creates and configures a new receiver to add to the simulation.
* `SetupRoom`: Configures room properties (size, absorption, diffusion, etc.).
* `MCRoomSimOptions`: Configures general parameters.
* `RunMCRoomSim`: Takes the outputs of the above four functions, combines them into an input structure that MCRoomSim accepts and then runs MCRoomSim.

Auxiliary functions are also provided
* `AirAbsorption`: Compute ISO standard frequency dependent air absorption values.
* `BandPassFilter`: Filter signals into octave or third-octave bands.
* `Clap`: Convolve impulse responses with a clap sound and play it back.
* `EarlyDecayTime`: Calculate the Early Decay Times from a set of impulse responses.
* `EyringKuttruffReverberationTime`:	Calculate the reverberation time of the room described by the 'Room' configuration structure using the Eyring-Kuttruff formula.
* `FitzroyKuttruffReverberationTime`:	Calculate the reverberation time of the room described by the 'Room' configuration structure using the Fitzroy-Kuttruff formula. This formula is supposed to give slightly better results than the Eyring formula when the wall absorptions are uneven (e.g. more absorbant floor and ceiling).
* `GenSHIndices`: Generate a 2 column vector that show the mapping of source/receiver channels to spherical harmonic components, as used in MCRoomSim.
* `MusicalClarity`: Calculate the Musical Clarity Index (C80) from a set of impulse responses.
* `PlotSimSetup`: Plots a 3D room with the source and receiver positions as well as indicating their orientation.
* `ReverberationTime`: Calculate the reverberation times (T30) from a set of impulse responses.
* `SchroederCurve`: Calculate the Schroeder curves from a set of impulse responses.
* `SpeechClarity`: Calculate the Speech Clarity Index (C50) from a set of impulse responses.	

If you use this software as part of your research, please cite our paper:  
_Room acoustics simulation for multichannel microphone arrays_  
_A. Wabnitz, N. Epain, C. Jin and A. van Schaik, in Proceedings of the International Symposium on Room Acoustics (ISRA), Melbourne Australia, August 2010_
