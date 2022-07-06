%% Set paths
%*This assumes that the project folder has maxdepth=2: project folder at
%depth0, patient folders at depth1, and niftis at depth2.
%
%*i.e.that all patient folders are within one root/project folder,
%and that each patient folder only contains the niftis.
%
%*project folder
% > patient folders
%    > nifti files
path_to_patientFolders = 'replace_with_your_filepath'; 
patientFolders = dir(fullfile(path_to_patientFolders));
patientFolders = patientFolders(3:end);


%% Main for-loop
%Pre-allocate for speed
pixelDims = cell(numel(patientFolders),1);
for p = 1:numel(patientFolders)
    %Replace with dicominfo(___) if needed
    niiFile = dir(fullfile(patientFolders(p).folder, patientFolders(p).name, '*.nii'));
    niiFile = niiFile(1);
    hdr = niftiinfo(fullfile(niiFile.folder, niiFile.name));
    pixelDims{p} = hdr.PixelDimensions(1:3);
end

%% Find unique pixel dimensions
uniquePixelDims = {};
for p = 1:numel(patientFolders)
    currentPixelDim = pixelDims{p};
    if ~isempty(uniquePixelDims)
        matchingIdx = cellfun(@(x) x==currentPixelDim, uniquePixelDims, 'UniformOutput', false);
        matchingIdx = cellfun(@all, matchingIdx, 'UniformOutput', true);
        if (~any(matchingIdx))
            uniquePixelDims{end+1,1} = currentPixelDim;
        end
    else
        uniquePixelDims{end+1,1} = currentPixelDim;
    end
end
