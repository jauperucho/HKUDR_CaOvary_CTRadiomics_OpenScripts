%% Instructions for use
% 1) Depending on what file structure the image files are stored, run the
% relevant section, or comment out the irrelevant sections before running
% the entire script.
% 2) Once nifti files have been read and individual pixel dimensions have
% been stored, run the last section "Find unique pixel dimensions"

%% Type 1 file structure
%*This assumes that the project folder has maxdepth=2: project folder at
%depth0, patient folders at depth1, and niftis at depth2.
%
%*i.e.that all patient folders are within one root/project folder,
%and that each patient folder only contains the niftis.
%
%*project folder
% > patient folders
%    > nifti files
path_to_projectFolder = 'replace_with_your_filepath'; 
patients = dir(fullfile(path_to_projectFolder));
patients = patients(3:end);

%Pre-allocate for speed
pixelDims = cell(numel(patients),1);
for p = 1:numel(patients)
    %Replace with dicominfo(___) if needed
    niiFile = dir(fullfile(patients(p).folder, patients(p).name, '*.nii'));
    niiFile = niiFile(1);
    hdr = niftiinfo(fullfile(niiFile.folder, niiFile.name));
    pixelDims{p} = hdr.PixelDimensions(1:3);
end

%% Type 2 file structure
%*This assumes that the project folder has maxdepth=1: project folder at
%depth0, niftis at depth1
%
%*i.e.that all niftis are within one root/project folder,
%
%*project folder
% > nifti files
path_to_projectFolder = 'replace_with_your_filepath'; 
patients = dir(fullfile(path_to_projectFolder));
patients = patients(3:end);

%Pre-allocate for speed
pixelDims = cell(numel(patients),1);
for p = 1:numel(patients)
    %Replace with dicominfo(___) if needed
    niiFile = dir(fullfile(patients(p).folder, patients(p).name));
    hdr = niftiinfo(fullfile(niiFile.folder, niiFile.name));
    pixelDims{p} = hdr.PixelDimensions(1:3);
end

%% Find unique pixel dimensions
uniquePixelDims = {};
for p = 1:numel(patients)
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
