%   function [PV] = chainimages(matches)
%   Construct the point-view matrix with the matches found between
%   consecutive frames. This matrix has tracked points as columns and
%   views/frames as rows, and contains the indices of the descriptor for
%   each frame. Therefore, if a certain descriptors can be seen in all
%   frames, their columns are completely filled. Similarly, if it can be
%   matched only between frame 1 and 2, only the first 2 rows of the columns
%   will be non-zero.
%
% Inputs:
% - num_desc: number of descriptors
% - matches: cell array containing matches indexes
%
% Outputs:
% - PV: matrix containing matches between consecutive frames
function PV = chain_images(num_desc, matches);
	PV = zeros(length(matches), size(num_desc, 2));
	for i=1:length(matches)
		match_i_idxs = matches{i};
		PV(i, match_i_idxs) = 1;
	end
end
