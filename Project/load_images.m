function imgs = load_images(directory, format)
	files = dir(fullfile(directory, strcat('*.', format)));
	imgs = {};
	for i = 1 : length(files)
		baseFilename = files(i).name;
		fullFilename = fullfile(directory, baseFilename);
		fprintf('Reading image %s\n', fullFilename);
		img = imread(fullFilename);
		imgs{i} = single(rgb2gray(img));
	end
end
