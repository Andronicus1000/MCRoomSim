function [head] = load_sonova_hrtf(filestem)
% Load sonova HRTFs
sonova_file_dir = '/Users/225ychoi/code/razr/base/hrtf/sonova/';
filename_l = strcat(sonova_file_dir, filestem, '_L.mat');
filename_r = strcat(sonova_file_dir, filestem, '_R.mat');

head = load(filename_l);
right_ir = load(filename_r);

% Concatenate the HRIRs in the channel dimension.
head.hrtf_data = cat(3, head.hrtf_data, right_ir.hrtf_data);
end


% function [indices] = get_closest_index(angles, query_angles)
% % Closest angle indices of the angles with the query angles.
% angles_shape = size(angles);
% angles = reshape(angles, [angles_shape(1) 1 angles_shape(2)]);
% query_angles = reshape(query_angles, [1 size(query_angles)]);
% squared_distance = sum((angles - query_angles).^2, 3);
% [~, indices] = min(squared_distance, [], 1);
% end