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
	all_descs = descs{1}(:, forward_matches{1});
	all_coords = {};
	all_coords{1} = zeros(2, length(forward_matches{1}));
	all_coords{1}(1,:) = frames{1}(1, forward_matches{1});
	all_coords{1}(2,:) = frames{1}(2, forward_matches{1});
	all_matches = {};
	all_matches{1} = [1:length(forward_matches{1})];

	for i=2:length(forward_matches)
		% Set new matches in all_matches{i}
		all_matches{i} = [1:length(forward_matches{i})];
		% Set all_coords{i}
		all_coords{i} = zeros(2, size(all_descs, 2));
		% Find old matches, set old matches in all_matches{i}
		old_matches_idxs = intersect(forward_matches{i}, backward_matches{i});
		for j=1:length(old_matches_idxs)
			% Find the old match index by nearest neighbor search in descriptors
			% This is imprecise but good enough for us.
			old_match = descs{i}(:, old_matches_idxs(j));
			curr_best_dist = inf;
			current_best_match_idx = -1;
			for k=1:size(all_descs, 2)
				other_desc = all_descs(:, k);
				eulc_dist = norm(single(old_match - other_desc));
				if eulc_dist < curr_best_dist
					current_best_match_idx = k;
					curr_best_dist = eulc_dist;
				end
			end
			all_matches{i}(j) = current_best_match_idx;
			all_coords{i}(:, current_best_match_idx) = frames{i}(1:2, old_matches_idxs(j));
		end
		% Find new matches
		new_matches_idxs = setdiff(forward_matches{i}, backward_matches{i});
		new_descs = descs{i}(:, new_matches_idxs);
		new_coords = frames{i}(1:2, new_matches_idxs);
		all_coords{i} = [all_coords{i}, zeros(2, length(new_matches_idxs))];
		for j=1:length(new_matches_idxs)
			all_matches{i}(end-length(new_matches_idxs)+j) = j + length(all_descs);
			all_coords{i}(:, j + length(all_descs)) = frames{i}(1:2, new_matches_idxs(j));
		end
		% Set new descs
		all_descs = [all_descs, new_descs];
	end

	% % Go back and pad all_coords with zeros to the size of all_descs
	% num_descs = size(all_descs, 2);
	% for i=1:length(forward_matches)
	% 	num_till_here = length(all_coords{i});
	% 	all_coords{i} = [all_coords{i}(:, :), zeros(2, num_descs - num_till_here)];
		% disp((all_matches{i}));
	% end

	% disp(size(all_descs));
	% disp(size(all_coords{2}));
	% disp(size(all_matches{2}));
end




