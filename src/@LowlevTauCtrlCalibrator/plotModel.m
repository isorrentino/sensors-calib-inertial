function plotModel( obj,frictionOrKtau,theta,xVar,nbSamples )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

% Resample the data for later plotting
[xs,ys] = Regressors.resampleDataSym(...
    theta,xVar,nbSamples);

% Get and select the figure where we plotted the scattered training data
% (figuresHandlerMap) is a Constant property that can be accessed through
% the class name, but also through 'obj'
figuresHandler = obj.figuresHandlerMap(obj.task);
switch frictionOrKtau
    case 'friction'
        figLabel = 'motorVel2torq';
    case 'ktau'
        figLabel = 'motorPWM2torq';
    otherwise
        error('calibrateSensors: unknown calibration type !!');
end
figH = figuresHandler.getFigure(figLabel);
figure(figH);

% Plot the data and the model
hold on;
plot(xs,ys,'r','lineWidth',4.0);
legend('Location','BestOutside','Training data','Model');

end

