%% ----------------------eyelink setup-------------------------------
% fixationWindow = [winWidth/2-hor_threshold,winHeight/2-vert_threshold,...
%     winWidth/2+hor_threshold,winHeight/2+vert_threshold];
% fixationWindow2 = [winWidth/2-hor_threshold2,winHeight/2-vert_threshold2,...
%     winWidth/2+hor_threshold2,winHeight/2+vert_threshold2];
% fixationWindow3 = [winWidth/2-hor_threshold3,winHeight/2-vert_threshold3,...
%     winWidth/2+hor_threshold3,winHeight/2+vert_threshold3];
dummymode = 0;
el=EyelinkInitDefaults(w);
% We are changing calibration to a black background with white targets,
%  smaller targets
el.backgroundcolour = BlackIndex(w);
el.msgfontcolour  = WhiteIndex(w);
el.calibrationtargetcolour= WhiteIndex(w);
el.calibrationtargetsize= 1;
el.calibrationtargetwidth=0.5;
EyelinkUpdateDefaults(el);
% Initialization of the connection with the Eyelink tracker
% exit program if this fails.
if ~EyelinkInit(dummymode)
    fprintf('Eyelink Init aborted.\n');
    cleanup;  % cleanup function
    return;
end

% open file to record data to
res = Eyelink('Openfile', edffilename);
if res~=0
    fprintf('Cannot create EDF file ''%s'' ', edffilename);
    cleanup;
    return;
end

% make sure we're still connected.
if Eyelink('IsConnected')~=1 && ~dummymode
    cleanup;
    return;
end
% SET UP TRACKER CONFIGURATION
% Setting the proper recording resolution, proper calibration type,
% as well as the data file content;
Eyelink('command', 'add_file_preamble_text ''Recorded by EyelinkToolbox visual search-experiment''');

% This command is crucial to map the gaze positions from the tracker to
% screen pixel positions to determine fixation
Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, winWidth-1, winHeight-1);

Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, winWidth-1, winHeight-1);
% set calibration type.
Eyelink('command', 'calibration_type = HV5');
Eyelink('command', 'generate_default_targets = YES');
% set parser (conservative saccade thresholds)
Eyelink('command', 'saccade_velocity_threshold = 35');
Eyelink('command', 'saccade_acceleration_threshold = 9500');

% 5.1 retrieve tracker version and tracker software version
[v,vs] = Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );
vsn = regexp(vs,'\d','match');

% set EDF file contents. Note the FIXUPDATE event for fixation update
% if EL 1000 and tracker version 4.xx
% remote mode possible add HTARGET ( head target)
Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT,HTARGET');
% set link data (used for gaze cursor)
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT,FIXUPDATE');
Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT,HTARGET');

% allow to use the big button on the eyelink gamepad to accept the
% calibration/drift correction target
Eyelink('command', 'button_function 5 "accept_target_fixation"');
Eyelink('AcceptTrigger');
% Tell the Eyelink to send a fixation update every 50 ms
Eyelink('command', 'fixation_update_interval = %d', 50);
Eyelink('command', 'fixation_update_accumulate = %d', 50);

% enter Eyetracker camera setup mode, calibration and validation
EyelinkDoTrackerSetup(el);

% get eye that's tracked
eye_used = Eyelink('EyeAvailable');
% returns 0 (LEFT_EYE), 1 (RIGHT_EYE) or 2 (BINOCULAR) depending on what data is
if eye_used ~= 0
    eye_used = 0; % use the left_eye data
end
