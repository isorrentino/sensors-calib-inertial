function runSeq = seqMap2runner( obj,seqParamsMap )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% build the array with all the expanded key labels and the associated
% tables. 1 key/value of 'seqParamsMap' => 1 line of result array formated
% as follows:
% key <-- seqParamsMap.keys{i}
% <action>,<sensor>,<part> <-- expand(key)
% sequence{i,:} <-- <action>,<sensor>,<part>,seqParamsMap(key)
for cellKey = seqParamsMap.keys
    key = cellKey{:};
    % expand key into labels
    dict = SequenceParams.labelKeys2ActSensPart;
    keyLabels = dict(key);
    % set the resulting field of the result array to the value seqParamsMap(key)
    runSeq.(keyLabels{1}).(keyLabels{2}).(keyLabels{3}) = seqParamsMap(key).val;
end

% list of parts for control
runSeq.ctrl.part = fieldnames(runSeq.ctrl.pos)';
% reshape 'pos'
runSeq.ctrl.pos = struct2cellConcat(runSeq.ctrl.pos);
% reshape 'vel'
if ismember('vel',fieldnames(runSeq.ctrl))
    runSeq.ctrl.vel = struct2cellConcat(runSeq.ctrl.vel);
else
    runSeq.ctrl.vel = runSeq.ctrl.pos;
    [runSeq.ctrl.vel{:}] = deal([]);
end

if ismember('meas',fieldnames(runSeq))
    % list of sensors for measurements
    runSeq.meas.sensor = fieldnames(runSeq.meas)';
    % list of parts and 'acquire' flag for measurements
    [runSeq.meas.part,runSeq.meas.acquire] = cellfun(...
        @(sensor) deal(...
        fieldnames(runSeq.meas.(sensor))',...
        cell2mat(struct2cellConcat(runSeq.meas.(sensor)))),...
        runSeq.meas.sensor,...
        'UniformOutput',false);
    % remove obsolete fields
    for cField = runSeq.meas.sensor
        field = cField{:};
        runSeq.meas = rmfield(runSeq.meas,field);
    end
    % set logger function
    runSeq.logCmd = obj.logCmd;
else
    runSeq.meas.sensor = {}; runSeq.meas.part = {}; runSeq.meas.acquire = {};
    % set logger function
    runSeq.logCmd = obj.dummyCmd;
end

if ismember('calib',fieldnames(runSeq))
    % list of calibrated sensor modalities
    runSeq.calib.sensor = fieldnames(runSeq.calib)';
    % list of calibrated parts
    runSeq.calib.part = cellfun(...
        @(sensor) fieldnames(runSeq.calib.(sensor))',...
        runSeq.calib.sensor,...
        'UniformOutput',false);
    % remove obsolete fields
    for cField = runSeq.calib.sensor
        field = cField{:};
        runSeq.calib = rmfield(runSeq.calib,field);
    end
    % set logger function
    runSeq.logCmd = obj.logCmd;
else
    runSeq.calib.sensor = {}; runSeq.calib.part = {};
    % set logger function
    runSeq.logCmd = obj.dummyCmd;
end

if ismember('pwmctrl',fieldnames(runSeq))
    % list of join/motor groups
    runSeq.pwmctrl.motor = cell2mat(fieldnames(runSeq.pwmctrl.pwm));
    % reshape 'pwm'
    runSeq.pwmctrl.pwm = struct2cellConcat(runSeq.pwmctrl.pwm);
    % transition
    if ismember('trans',fieldnames(runSeq.pwmctrl))
        runSeq.pwmctrl.trans = runSeq.pwmctrl.trans.(runSeq.pwmctrl.motor);
        runSeq.pwmctrl.freq = runSeq.pwmctrl.freq.(runSeq.pwmctrl.motor);
    else
        runSeq.pwmctrl.trans(1:numel(runSeq.pwmctrl.pwm)) = {'level'};
    end
end

% Mode handling
if ismember('mode',fieldnames(runSeq))
    % copy respective content
    runSeq.mode = runSeq.mode.NA.NA;
else
    % default value
    runSeq.mode = cell(size(runSeq.ctrl.pos,1),1);
    runSeq.mode(:) = {'ctrl'};
end

% Prompt handling
if ismember('prpt',fieldnames(runSeq))
    % copy respective content
    runSeq.prpt = runSeq.prpt.NA.NA;
else
    % default value
    runSeq.prpt = cell(size(runSeq.ctrl.pos,1),1);
    runSeq.prpt(:) = {@() []};
end

end

function rowVecConcat = struct2cellConcat(aStruct)

cellArray=struct2cell(aStruct);
rowVecConcat = [cellArray{:}];

end


% % EXAMPLE 1
% 
% runSeq.calib.sensor = {'joint'};
% 
% runSeq.calib.part = {{'right_arm','head'}};
% 
% runSeq.ctrl.part = {'right_arm','head'};
% 
% runSeq.ctrl.pos = {...
%     [  0 45 -23 50 0 0 0],[0 0 0];...
%     [  0 45  49 50 0 0 0],[0 0 0];...
%     [  0 45   0 50 0 0 0],[0 0 0];...
%     [-20 30 -30 90 0 0 0],[0 0 0];...
%     [-20 30 -30  0 0 0 0],[0 0 0];...
%     [-20 30 -30 90 0 0 0],[0 0 0];...
%     [ 0  45   0 50 0 0 0],[0 0 0];...
%     [ 0  45   0 50 0 0 0],[0 0 0]};
% 
% runSeq.ctrl.vel = {
%     [10 10 10 10 10 10 10],[10 10 10];...
%     [10 10 10 10 10 10 10],[10 10 10];...
%     [10 10 10 10 10 10 10],[10 10 10];...
%     [10 10 10 10 10 10 10],[10 10 10];...
%     [10 10 10 10 10 10 10],[10 10 10];...
%     [10 10 10 10 10 10 10],[10 10 10];...
%     [10 10 10 10 10 10 10],[10 10 10];...
%     [10 10 10 10 10 10 10],[10 10 10]};
% 
% runSeq.meas.sensor = {'joint','acc','imu'};
% 
% runSeq.meas.part = {...
%     {'right_arm','torso','head'},...
%     {'right_arm'},...
%     {'head'}};
% 
% runSeq.meas.acquire = {...
%     {...
%     [true       ,true       ,false      ];...
%     [true       ,true       ,true       ];...
%     [true       ,true       ,true       ];...
%     [false      ,true       ,true       ];...
%     [true       ,true       ,false      ];...
%     [true       ,true       ,false      ];...
%     [false      ,false      ,false      ];...
%     [false      ,false      ,false      ]},...
%     {...
%     [true       ];...
%     [true       ];...
%     [true       ];...
%     [false      ];...
%     [true       ];...
%     [true       ];...
%     [false      ];...
%     [false      ]},...
%     {...
%     [false      ];...
%     [true       ];...
%     [true       ];...
%     [true       ];...
%     [false      ];...
%     [false      ];...
%     [false      ];...
%     [false      ]}};

% % EXAMPLE 2
% 
% runSeq.calib.sensor = {'LLTctrl'};
% 
% runSeq.calib.part = {{'right_arm'}};
% 
% runSeq.ctrl.part = {'right_arm'};
% 
% runSeq.ctrl.pos = {...
%     [  0 45 -23 50 0 0 0];...
%     [  0 45  49 50 0 0 0]};
% 
% runSeq.ctrl.vel = {
%     [10 10 10 10 10 10 10];...
%     [10 10 10 10 10 10 10]};
% 
% runSeq.pwmctrl.motor = 'r_shoulder_grp';
% 
% runSeq.pwmctrl.pwm = {
%     0;...
%     0};
% 
% runSeq.mode = {
%     'ctrl';...
%     'pwmctrl'};
% 
% runSeq.prpt = {
%     @() [];...
%     @() 'some text'};
% 
% runSeq.meas.sensor = {'joint','jtorq'};
% 
% runSeq.meas.part = {...
%     {'right_arm'},...
%     {'right_arm'}};
% 
% runSeq.meas.acquire = {...
%     {...
%     [false      ];...
%     [true       ]},...
%     {...
%     [false      ];...
%     [true       ]}};

