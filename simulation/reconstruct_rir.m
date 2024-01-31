function [rir] = reconstruct_rir(rir_sim, original_fs, resample_fs, rir_length)
% Aggregate the simlated MCRoom RIR and return the RIR as an array of shape 
% (num_sources, num_samples, num_channels).
% We do resampling and cropping/padding.

    %% Concatenate the IRs in (num_sources, num_samples, num_channels) shapes.
    num_sources = numel(rir_sim);
    % Aggregate
    rir = zeros([num_sources size(rir_sim{1})]);
    for i = 1:num_sources
        rir(i, :, :) = rir_sim{i};
    end
    
    %% Resample
    if original_fs ~= resample_fs
        rir = permute(resample(double(permute(rir, [2 1 3])), resample_fs, original_fs), [2 1 3]);
    end
    
    %% Crop or zero-pad
    if rir_length < size(rir, 2)
        rir = rir(:, 1:rir_length, :);
    else
        rir = padarray(rir, [0, rir_length - size(rir, 2), 0], 0, 'post');
    end
end