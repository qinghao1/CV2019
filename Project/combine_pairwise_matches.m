%   function [all_descs, all_coords, all_matches] = combine_pairwise_matches(frames, descs, forward_matches)
%   Reduce pairwise features/coordinates/matches to a single array for each.
%
%
% Outputs:
% - all_descs: matrix containing #descriptors * 128d descriptor
% - all_coords: cell array where all_coords{img}[idx] is the coordinates for feature idx
% 	in image img.
% - all_matches: cell array where all_matches{img} is the index of forward matches for
% 	that image img.
function [all_descs, all_coords, all_matches] = combine_pairwise_matches(frames, descs, forward_matches, backward_matches);
	% Initialize the return values using first frame/desc/match
	all_descs = descs{1}(forward_matches{1});
	all_coords = {};
	% all_coords{1} = zeros(2, length(forward_matches{1}));
	% all_coords{1}(1,:) = frames{1}(1, forward_matches{1});
	% all_coords{1}(2,:) = frames{1}(2, forward_matches{1});
	all_matches = {};
	all_matches{1} = [1:size(forward_matches{1})];

	for i=2:length(forward_matches)
		% Find new matches
		new_matches_idxs = setdiff(forward_matches{i}, backward_matches{i});
		new_descs = descs{i}(new_matches_idxs);
		new_coords = frames{i}(1:2, new_matches_idxs);
		% Set new matches in all_matches{i}
		all_matches{i} = zeros(size(forward_matches{i}));
		for j=1:length(new_matches_idxs)
			all_matches{i}(end-length(new_matches_idxs)+j) = j + length(all_descs);
		% Set new descs
		all_descs = [all_descs, new_descs];
		% Find old matches, set old matches in all_matches{i}
		old_matches_idxs = intersect(forward_matches{i}, backward_matches{i});
		for j=1:length(old_matches_idxs)
			% Find the old match index by nearest neighbor search in descriptors.
			% This is imprecise but good enough for us.
			old_match = descs{i}(:, old_matches_idxs(j));
			for k=1:length(all_descs)

			end
			% all_matches{i}[j] =
		end
		% all_coords = [all_coords, new_coords];
	end
end




