function plotFuncTimeseries(...
    figuresHandler,aTitle,aLabel,...
    time,y,...
    yLabel)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

% create figure
figH = figure('Name',aTitle,'WindowStyle', 'docked');

if ~isempty(figuresHandler)
    figuresHandler.addFigure(figH,aLabel); % Add figure to the figure handler
end

% If the figure is not docked, use the below command to display it full
% screen.
%set(gcf,'PositionMode','manual','Units','normalized','outerposition',[0 0 1 1]);
title(aTitle,'Fontsize',16,'FontWeight','bold');
hold on

plot(time,y,'b','lineWidth',1.0);

hold off
grid ON;
xlabel('Time (sec)','Fontsize',12);
ylabel(yLabel,'Fontsize',12);
set(gca,'FontSize',12);

end

