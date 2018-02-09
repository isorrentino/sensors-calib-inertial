classdef SensorDiagnosis
    %SensorDiagnosis Holds all methods for running a diagnosis on sensor data
    %   'runDiagnosis()' is the main procedure for checking the inertial
    %   sensors data and plotting the key performance indicators related to
    %   the sensors calibration.
    
    methods(Static = true, Access = public)
        runDiagnosis(...
            dataPath,measedSensorList,measedPartsList,model,taskSpecificParams,...
            figuresHandlerMap,task);
    end
    
    methods(Static = true, Access = protected)
        checkAccelerometersAnysotropy(...
            data_bc,data_ac,sensorsIdxListFile,...
            sensMeasCell_bc,sensMeasCell_ac,...
            figuresHandler);
        
        [pVec,dVec,dOrient,d] = ellipsoid_proj_distance_fromExp(x,y,z,centre,radii,R);
        
        angleList = checkSensorMeasVsEst(...
            data,sensorsIdxListFile,...
            sensMeasCell,sensEstCell,...
            figuresHandler,logtag);
        
        checkSensorMeasVsEstAngleImprovmt(...
            data,sensorsIdxListFile,...
            angleList_bc,angleList_ac,...
            figuresHandler);
        
        plotFittingEllipse(centre,radii,R,sensMeasCell);
        
        plotJointTrajectories(data,modelParams,figuresHandler);
        
        [h,ditribLogString] = plotNprintDistrb(dOrient,fitGaussian,color,alpha,prevh,axbc,axac);
    end
    
end
