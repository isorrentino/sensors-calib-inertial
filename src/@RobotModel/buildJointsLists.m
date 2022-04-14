function jointsListFromPart = buildJointsLists()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% macros for repetitive names and codes between left and right parts
%
armJoints = @(side) {...
    [side '_shoulder_pitch'],[side '_shoulder_roll'],[side '_shoulder_yaw'],...
    [side '_elbow']};

legJoints = @(side) {...
    [side '_hip_pitch'],[side '_hip_roll'],[side '_hip_yaw'], ...
    [side '_knee'],...
    [side '_ankle_pitch'],[side '_ankle_roll']};

%% Lists

% Parts list
parts = {'left_arm','right_arm','left_leg','right_leg','torso','head'};

% Joints lists: All robot joints except wrists and hands.
% These joint lists are the ones given to the Yarp PolyDriver by the
% RemoteControlBoardRemapper (for controlling the joint motors)
% (refer to 'setEncoders/getEncoders methods). So the order in '.ctrledJoints'
% list has to match the one of the q vector in stateExt:o yarp port.
% TO_BE_IMPROVED.
jointsLists = {...
    armJoints('l'),armJoints('r'),...
    legJoints('l'),legJoints('r'),...
    {'torso_yaw','torso_roll','torso_pitch'},...
    {'neck_pitch', 'neck_roll', 'neck_yaw'}};

% Build map table
jointsListFromPart = containers.Map(parts,jointsLists);

end

