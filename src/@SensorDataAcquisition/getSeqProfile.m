function [seqHomeParams,seqEndParams,selector] = getSeqProfile(task,taskSpecificParams)
%getSeqProfile Loads the sequence profile parameters from a script ini file
%   The script holding the sequence parameters is selected by the tag 'seqProfileTag' 

% default output
seqHomeParams = {};
seqEndParams = struct();
selector = struct();

switch task
    case JointEncodersCalibrator.task
        run jointsCalibratorSequenceProfileWOsuspend;
    case accelerometersCalibrator.task
        run accelerometersCalibratorSequenceProfileWOsuspend;
    case SensorDataAcquisition.task
        run(taskSpecificParams.motionSeqProfile);
    case LowlevTauCtrlCalibrator.task
        % init joint/motors group label variable for the profile script
        jtmotgrp = taskSpecificParams.jointMotorGroupLabel;
        switch taskSpecificParams.frictionOrKtau
            case 'friction'
                % run the profile script for friction identification
                run lowLevTauCtrlCalibratorSequenceProfile1;
            case 'ktau'
                % run the profile script for friction identification
                run lowLevTauCtrlCalibratorSequenceProfile2;
            otherwise
                error('Unknown low level control calibration phase!');
        end
    otherwise
        error('Unknown task (sequence profile) !!');
end

end

