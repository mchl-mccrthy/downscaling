% Format figure to improve aesthetics

% % Example usage
% fig = figure;
% plot(rand(100, 1)); hold on
% xlabel('Time (s)');
% ylabel('Q (m^3 s^{-1})');
% 
% formatfigure(fig,7,2.5,1)

% Michael McCarthy 2024

function formatfigure(figHand,plotWidth,plotHeight,margin)

% Specify line width, font size, tick length
lineWidth = 1.5;
boxLineWidth = 0.5;
fontSize = 8;
tickLength = 1.5;

% Set figure size
figWidth = margin+plotWidth+margin;
figHeight = margin+plotHeight+margin;
set(figHand,'units','centimeters','position',[0 0 figWidth figHeight]);

% Set axis size
axHand = gca(figHand);
set(axHand,'Units','centimeters');
set(axHand,'Position',[margin margin plotWidth plotHeight]);

% Get axis handle and set font etc
set(axHand,'FontName','Helvetica','FontSize',fontSize);
box(axHand,'on');
axHand.TickLength = [tickLength/plotWidth/10 tickLength/plotHeight/10];

% Change width of data lines
axLines = findobj(axHand,'Type','line');
set(axLines,'LineWidth',lineWidth);

% Set the box line width separately
axHand.LineWidth = boxLineWidth;

% Ensure the figure is displayed correctly
drawnow;

end
