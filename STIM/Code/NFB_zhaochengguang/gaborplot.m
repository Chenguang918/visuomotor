function [gabortex,propertiesMat]=gaborplot(windowRect,window,contrast,aspectRatio,phase,numCycles)
%  
%--------------------
% Gabor information
%--------------------
% Dimension of the region where will draw the Gabor in pixels
gaborDimPix = windowRect(4) / 2;

% Sigma of Gaussian
sigma = gaborDimPix / 7;

% Spatial Frequency (Cycles Per Pixel)
% One Cycle = Grey-Black-Grey-White-Grey i.e. One Black and One White Lobe
freq = numCycles / gaborDimPix;

% Build a procedural gabor texture (Note: to get a "standard" Gabor patch
% we set a grey background offset, disable normalisation, and set a
% pre-contrast multiplier of 0.5.
% For full details see:
% https://groups.yahoo.com/neo/groups/psychtoolbox/conversations/topics/9174
backgroundOffset = [0.5 0.5 0.5 0.0];
disableNorm = 1;
preContrastMultiplier = 0.5;
gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, [],...
    backgroundOffset, disableNorm, preContrastMultiplier);

% Randomise the phase of the Gabors and make a properties matrix.
propertiesMat = [phase, freq, sigma, contrast, aspectRatio, 0, 0, 0];

end