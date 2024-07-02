 % Clear the workspace and the screen
sca;
close all;
clearvars;

% Setup PTB with some default values
PsychDefaultSetup(2);

% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;

% Skip sync tests for demo purposes only
Screen('Preference', 'SkipSyncTests', 2);

% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2,...
    [], [],  kPsychNeed32BPCFloat);


%--------------------
% Gabor information
%--------------------

% Dimension of the region where will draw the Gabor in pixels
gaborDimPix = windowRect(4) / 2;

% Sigma of Gaussian  
sigma = gaborDimPix / 7;

% Obvious Parameters
orientation = 45;
contrast = 0.5 ;
aspectRatio = 1.0;
phase = 50;

% Spatial Frequency (Cycles Per Pixel)
% One Cycle = Grey-Black-Grey-White-Grey i.e. One Black and One White Lobe
numCycles = 4;
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


%------------------------------------------
%    Draw stuff - button press to exit
%------------------------------------------

% Draw the Gabor. By default PTB will draw this in the center of the screen
% for us.
Screen('DrawTextures', window, gabortex, [], [], orientation, [], [], [], [],...
    kPsychDontDoRotation, propertiesMat');

% Flip to the screen
Screen('Flip', window);

% Wait for a button press to exit
KbWait;

% Clear screen
sca;