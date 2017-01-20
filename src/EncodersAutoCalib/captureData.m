%% clear all variables and close all previous figures
clear
close all
clc

%% Main interface parameters ==============================================
parts = {'right_leg','head','torso'};
dataPath  = '../../data/calibration/dumper/icubSim#1/';

%% Home single step sequence

% For limbs calibration
homeCalibLimbs.parts = {...
    'left_arm','right_arm',...
    'left_leg','right_leg',...
    'torso','head'};
homeCalibLimbs.pos = {...
    [0 45 0 50 0 0 0],...
    [0 45 0 50 0 0 0],...
    [0 10 0 0 0 0],...
    [0 10 0 0 0 0],...
    [0 0 0],...
    [0 0 0]};
homeCalibLimbs.vel = {...
    repmat(10,[1 7]),...
    repmat(10,[1 7]),...
    repmat(10,[1 6]),...
    repmat(10,[1 6]),...
    repmat(10,[1 3]),...
    repmat(10,[1 3])};
homeCalibLimbs.acquire=cell(size(homeCalibLimbs.parts));
homeCalibLimbs.acquire(:)={false};

% For torso calibration
homeCalibTorso = homeCalibLimbs;
homeCalibTorso.pos = {...
    [-30 30 -30 20 0 0 0],...
    [-30 30 -30 20 0 0 0],...
    [0 10 0 0 0 0],...
    [0 10 0 0 0 0],...
    [0 0 0],...
    [0 0 0]};

%% Motion sequences
% (a single sequence is intended to move all defined parts synchronously,
%  motions from 2 different sequences should be run asynchronously)

% define tables for each limb
left_arm_posVel_seq = {...
    [0 45 -30 90 0 0 0],repmat(10,[1 7]),false;...
    [0 45 -23 50 0 0 0],repmat( 4,[1 7]),true;...
    [0 45  49 50 0 0 0],repmat( 4,[1 7]),true;...
    [0 45   0 50 0 0 0],repmat( 4,[1 7]),true;...
    [0 45  49 90 0 0 0],repmat(10,[1 7]),false;...
    [0 45  49  0 0 0 0],repmat( 4,[1 7]),true;...
    [0 45  49 50 0 0 0],repmat( 4,[1 7]),true;...
    [],[],false};

right_arm_posVel_seq = left_arm_posVel_seq;

left_leg_posVel_seq = {...
    [ 0 45 -60   0   0   0],repmat(10,[1 6]),false;...
    [ 0 45  60   0   0   0],repmat( 4,[1 6]),true;...
    [80 45   0   0   0   0],repmat(10,[1 6]),false;...
    [80 45   0 -80   0   0],repmat( 4,[1 6]),true;...
    [80 45   0 -80 -25   0],repmat( 2,[1 6]),true;...
    [80 45   0 -80  25   0],repmat( 2,[1 6]),true;...
    [80 45   0 -80   0 -20],repmat( 2,[1 6]),true;...
    [80 45   0 -80   0  20],repmat( 2,[1 6]),true};

right_leg_posVel_seq = left_leg_posVel_seq;

torso_posVel_seq = {...
    [0 0 0],repmat(10,[1 3]),false;...
    [0 0 0],repmat( 4,[1 3]),true;...
    [0 0 0],repmat( 4,[1 3]),true;...
    [0 0 0],repmat( 4,[1 3]),true;...
    [],[],false;...
    [],[],false;...
    [],[],false;...
    [],[],false};

head_posVel_seq = {...
    [0 0 0],repmat(10,[1 3]),false;...
    [0 0 0],repmat( 4,[1 3]),true;...
    [0 0 0],repmat( 4,[1 3]),true;...
    [0 0 0],repmat( 4,[1 3]),true;...
    [],[],false;...
    [],[],false;...
    [],[],false;...
    [],[],false};

% define sequences for limbs and torso calibration
[emptySeq.part,emptySeq.pos,emptySeq.vel,emptySeq.acquire]=deal({});
seqSets{1} = {homeCalibLimbs;emptySeq};
seqSets{2} = {homeCalibTorso;emptySeq};

% Map parts to sequences
selector_part = {...
    'left_arm','right_arm',...
    'left_leg','right_leg',...
    'torso','head'};
selector_seqSetIdx  = {1,1,1,1,2,1};
selector_seqParams = {...
    left_arm_posVel_seq,right_arm_posVel_seq,...
    left_leg_posVel_seq,right_leg_posVel_seq,...
    torso_posVel_seq,head_posVel_seq};
selector.seqSetIdx = containers.Map(selector_part,selector_seqSetIdx);
selector.seqParams = containers.Map(selector_part,selector_seqParams);

% Check that requested parts are handled
if ~ismember(parts,keys(selector.seqSetIdx))
    error('...part not handled or part list empty!');
end

% Build sequences: concatenate previous tables depending on 'parts'
for part = parts
    % decapsulate part
    part = part{:};
    % select te target list of sequences
    seqSetIdx = selector.seqSetIdx(part);
    seqParams = selector.seqParams(part);
    % build the sequence
    seqSets{seqSetIdx}{2}.part = [seqSets{seqSetIdx}{2}.part part];
    seqSets{seqSetIdx}{2}.pos  = [seqSets{seqSetIdx}{2}.pos seqParams(:,1)];
    seqSets{seqSetIdx}{2}.vel  = [seqSets{seqSetIdx}{2}.vel seqParams(:,2)];
    seqSets{seqSetIdx}{2}.acquire  = [seqSets{seqSetIdx}{2}.acquire seqParams(:,3)];
end

% Run sequence 1 and 2 iteratively
sequences = {};
for seqSet = seqSets
    % decapsulate seqSet
    seqSet = seqSet{:};
    % concatenate final composition of sequences
    if ~isempty(seqSet{2}.part)
        sequences = [sequences;seqSet];
    end
end

%% Training data acquisition

% create motion sequencer with defined sequences
sequencer = MotionSequencer(sequences);

% iteratively trigger next motion and acquire data

acquireDataForPart(part,sequences);

ctrlBoardRemap = RemoteControlBoardRemapper('icubSim',parts);

ctrlBoardRemap.moveToPos([0 0 0 0 0 0],'refVel',repmat(4,1,6));

[~,mat]=ctrlBoardRemap.getEncoders()
