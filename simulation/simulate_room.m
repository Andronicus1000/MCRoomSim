clear all; close all; clc;
warning('off', 'MATLAB:MKDIR:DirectoryExists');

% set seed
rng(1);

%% Constants

% Save folder
% store data here
razr_base_folder = '/Users/225ychoi/data/razr_simulation_results8k';
mcroomsim_basename = 'mcroomsim_results8k';
simulate_diffuse = false;

mcroomsim_fs = 44100;  % MCRoomSim requires fs >= 44.1kHz
rir_length = 8192;
[~, razr_basename] = fileparts(razr_base_folder);


%% Option
options = MCRoomSimOptions('Fs', mcroomsim_fs, 'SimDiff', simulate_diffuse, 'Verbose', false);

files = dir(fullfile(razr_base_folder, '**', 'room_*.mat'));

for i_room = 1:1
    razr_room_path = fullfile(files(i_room).folder, files(i_room).name);
    
    % Simulate the same room as in razr_room path using MCRoomSim, and save the
    % data.

    %% Load scene specs
    [room_rev, room_dry, receivers, sources, original_hrir_fs] = load_scene_specifications(razr_room_path, mcroomsim_fs);

    %% Simulate
    tic;
    rir_rev = RunMCRoomSim(sources, receivers, room_rev, options);
    rir_dry = RunMCRoomSim(sources, receivers, room_dry, options);
    duration = toc;
    duration_string = sprintf('%.2f', duration);
    disp([int2str(i_room), ': It took ', duration_string, ' seconds to simulate MCRoom RIR '])

    %% Reconstruct
    rir_rev = reconstruct_rir(rir_rev, mcroomsim_fs, original_hrir_fs, rir_length);
    rir_dry = reconstruct_rir(rir_dry, mcroomsim_fs, original_hrir_fs, rir_length);

    %% Save the data.
    filepath = replace(razr_room_path, razr_basename, mcroomsim_basename);
    save_ir_mat(filepath, rir_rev, rir_dry, room_rev, room_dry, sources, receivers)
end
