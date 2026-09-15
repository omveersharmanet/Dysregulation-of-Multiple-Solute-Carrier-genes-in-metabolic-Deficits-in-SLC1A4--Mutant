% close all;
% clear all;
load("C:\Users\omvee\Downloads\data_FigS5.mat")


data = [];
se_data = [];

% Iterate through results and build the data and se_data arrays
for i = 1:length(results)
    mean_events = results{i}.mean_amp;
    se_amp = results{i}.se_amp;
    
    % Append to data and se_data arrays
    data = [data; mean_events, i];
    se_data = [se_data, se_amp];
end

% Now, data and se_data contain the information for all groups

colors = {'b';
%     "#0072BD";"#7E2F8E";"#4DBEEE";[0.2010 0.5450 0.9830];'r';"#D95319";"#EDB120";"#A2142F";"#77AC30";
    'm';'r';'g';'k';'c';
    'w';
    'y',
    };



% Initialize uniNames
uniNames = cell(size(groups));

% Iterate through groups and extract the last part of each path
for i = 1:length(groups)
    [~, name, ~] = fileparts(groups{i});
    uniNames{i} = name;
end

% Calculate maximum y value for the plot
H = data(:, 1);
N = numel(H);
max_y = max(H) + max(se_data);
max_y = max_y + 0.2 * max_y;

% Create the figure
figure;
hold on;

% Plot the bars with appropriate colors
for i = 1:N
    h = bar(i, H(i), 0.5);
    if i == 1, hold on, end
    col = colors{data(i, 2)};
    set(h, 'FaceColor', col, 'EdgeColor', 'k', 'LineWidth', 1);
end

% Add error bars

errorb3(H, se_data', 'barWidth', 0.95, 'linewidth', 1);

% Customize plot appearance
set(gca, 'fontsize', 15);
set(gca, 'linewidth', 2);
% set(gca, 'XTickLabel', '');


numNeurons = zeros(1, length(results));

for i = 1:length(results)
    numNeurons(i) = length(results{i}.r_all_event);
end

% Create legends
legends = cell(size(uniNames));
for i = 1:length(uniNames)
    legends{i} = sprintf('%s (n=%d)', uniNames{i}, numNeurons(i));
end

legend(legends,'Location','Best')
ax = gca;
ax.Legend.AutoUpdate = 'off';
ylim([0, max_y]);
ypos = -(max(abs(ylim))) / 20;
% xlim([0, numel(uniNames) + 0.5]);
set(gca, 'fontsize', 20);
% x_positions = 0.75:1:(0.75 + numel(uniNames) - 1);
% text(x_positions, repmat(ypos, 1, numel(uniNames)), uniNames, 'FontSize', 13);
set(gca, 'XTick', 1:numel(uniNames));
set(gca, 'XTickLabel', uniNames);

ylabel('pA');
title('EPSC amplitude');
% Number of groups
num_groups = length(results);

% Generate all pairwise combinations of groups
combinations = nchoosek(1:num_groups, 2);

% Calculate y-positions dynamically based on max_y and the number of combinations
y_positions = linspace(max_y * 0.7, max_y * 0.9, size(combinations, 1));

% Loop through combinations to plot lines and add p-values
for k = 1:size(combinations, 1)
    group1 = combinations(k, 1);
    group2 = combinations(k, 2);
    
    % Calculate p-value using the appropriate groups
    [b, a] = ranksum(results{group1}.mean_amp_nonan, results{group2}.mean_amp_nonan);
    %     [a, b] = ttest2(results{group1}.mean_amp_nonan, results{group2}.mean_amp_nonan);
    
    % Check if the result is significant
    if b < 0.05
        y_pos = y_positions(k);
        
        % Define the x vector
        x = [group1 + 0.2:0.1:group2 - 0.2];
        
        % Define the y vector to have the same length as x
        y = ones(1, length(x)) * y_pos;
        
        % Plot the line connecting the groups
        plot(x, y, 'k');
        
        % Adjust the y position for adding the p-value, to avoid overlapping with the line
        p_value_y_pos = y_pos + (max_y * 0.02); % You can adjust the 0.05 factor to control the distance
        addPValueToPlot(mean([group1, group2]), p_value_y_pos, b);
    end
end
pvalues = zeros(num_groups);

for i = 1:num_groups
    for j = i+1:num_groups
        
        [pvals(i,j),~] = ranksum(results{i}.mean_amp_nonan, results{j}.mean_amp_nonan);
        pvalues(j,i) = pvals(i,j);
        
    end
end



hold off

%%%%%
figure
hold on
xx=[1:300];
for i = 1:length(results)
    plot (xx(1:100),results{i}.cumulative_dist(1:100),colors{i});
end


set(gca,'xTick',0:20:100,'FontSize',22)
title ('cumulative distribution','fontsize',22);
xlabel ('pA','fontsize',22)
legends = uniNames;
legend(legends,'Location','Best','FontSize',14)
fontname = 'Arial';
fontsize = 12;
fontweight = 'bold';
set(gca, 'FontName', fontname, 'FontSize', fontsize, 'FontWeight', fontweight);

hold off
%%

%%event rate

% Initialize data and se_data arrays
data = [];
se_data = [];

% Iterate through results and build the data and se_data arrays
for i = 1:length(results)
    mean_event_rate = results{i}.mean_rate;
    std_error = results{i}.se_rate;
    
    % Append to data and se_data arrays
    data = [data; mean_event_rate, i];
    se_data = [se_data, std_error];
end

% Now, data and se_data contain the information for all groups



% uniNames = {'T line', 'T line 1uM treated'}; % Add more labels if you have more groups

% Calculate maximum y value for the plot
H = data(:, 1);
N = numel(H);
max_y = max(H) + max(se_data);
max_y = max_y + 0.2 * max_y;

% Create the figure
figure;
hold on;

% Plot the bars with appropriate colors
for i = 1:N
    h = bar(i, H(i), 0.5);
    if i == 1, hold on, end
    col = colors{data(i, 2)};
    set(h, 'FaceColor', col, 'EdgeColor', 'k', 'LineWidth', 1);
end
errorb3(H, se_data', 'barWidth', 0.95, 'linewidth', 1);

% Customize plot appearance
set(gca, 'fontsize', 15);
set(gca, 'linewidth', 2);
set(gca, 'XTickLabel', '');
numNeurons = zeros(1, length(results));

for i = 1:length(results)
    numNeurons(i) = length(results{i}.r_all_event);
end

% Create legends
legends = cell(size(uniNames));
for i = 1:length(uniNames)
    legends{i} = sprintf('%s (n=%d)', uniNames{i}, numNeurons(i));
end
legend(legends,'Location','Best','AutoUpdate','off')
ylim([0, max_y]);
ypos = -(max(abs(ylim))) / 20;
% xlim([0, numel(uniNames) + 0.5]);
set(gca, 'fontsize', 20);
% x_positions = 0.5:1:(0.5 + numel(uniNames) - 1);
% text(x_positions, repmat(ypos, 1, numel(uniNames)), uniNames, 'FontSize', 13);
set(gca, 'XTick', 1:numel(uniNames));
set(gca, 'XTickLabel', uniNames);

ylabel('Hz');
title('EPSC rate');
% Number of groups
num_groups = length(results);

% Generate all pairwise combinations of groups
combinations = nchoosek(1:num_groups, 2);

% Calculate y-positions dynamically based on max_y and the number of combinations
y_positions = linspace(max_y * 0.81, max_y * 0.91, size(combinations, 1));
% Loop through combinations to plot lines and add p-values
for k = 1:size(combinations, 1)
    group1 = combinations(k, 1);
    group2 = combinations(k, 2);
    
    % Calculate p-value using the appropriate groups
    [b, a] = ranksum(results{group1}.r_all_event, results{group2}.r_all_event);
    %x=[results{group1}.r_all_event results{group2}.r_all_event];
    %group1=ones(size(results{group1}.r_all_event));
    %group2=2*ones(size(results{group2}.r_all_event));
    %group=[group1 group2];
    %     p = kruskalwallis(x,group)
    %[a, b] = ttest2(results{group1}.r_all_event, results{group2}.r_all_event);
    
    % Check if the result is significant
    if b < 0.05
        y_pos = y_positions(k);
        
        % Define the x vector
        x = [group1 + 0.2:0.1:group2 - 0.2];
        
        % Define the y vector to have the same length as x
        y = ones(1, length(x)) * y_pos;
        
        % Plot the line connecting the groups
        plot(x, y, 'k');
        
        % Adjust the y position for adding the p-value, to avoid overlapping with the line
        p_value_y_pos = y_pos + (max_y * 0.05); % You can adjust the 0.05 factor to control the distance
        addPValueToPlot(mean([group1, group2]), p_value_y_pos, b);
    end
end
pvalues_rate = zeros(num_groups);

for i = 1:num_groups
    for j = i+1:num_groups
        
        [pvals(i,j),~ ] = ranksum(results{i}.r_all_event, results{j}.r_all_event);
        pvalues_rate(j,i) = pvals(i,j);
        
    end
end
hold off
%%

% Function to calculate cumulative distribution
function cum_dist = calculate_cumulative_dist(events)
xx = 1:300;
cum_hist = hist(abs(events), xx);
cum_dist = cumsum(cum_hist);
cum_dist = cum_dist / cum_dist(end);
end

% Function to calculate mean events and event rates
function [m_all_event, r_all_event] = calculate_event_rate(events, length_events, index,day,min_day,max_day)
m_all_event = [];
r_all_event = [];
for j = 1:index
    if (day(j) >= min_day) && (day(j) <= max_day)
        m_all_event = [m_all_event, mean(abs(events{j}'))];
        r_all_event = [r_all_event, length(events{j}') / length_events(j)];
    end
end
end


function errorb3(x,y,varargin)
%% first things first
%save the initial hold state of the figure.
hold_state = ishold;
if ~hold_state
    cla;
end

h=[];

%% If you are plotting errobars on Matlabs grouped bar plot
if size(x,1)>1 && size(x,2)>1 % if you need to do a group plot
% Plot bars
    num2Plot=size(x,2);
    e=y; y=x;
	handles.bars = bar(x, 'edgecolor','k', 'linewidth', 2);
	hold on
	for i = 1:num2Plot
		x =get(get(handles.bars(i),'children'), 'xdata');
		x = mean(x([1 3],:)); 
%       Now the recursive call!
		errorb(x,y(:,i), e(:,i),'barwidth',1/(num2Plot),varargin{:}); %errorb(x,y(:,i), e(:,i),'barwidth',1/(4*num2Plot),varargin{:});
    end
    if ~hold_state
        hold off;
    end
    return; % no need to see the rest of the function
else
    x=x(:)';
    y=y(:)';
    num2Plot=length(x);
end
%% Check if X and Y were passed or just X

if ~isempty(varargin)
    if ischar(varargin{1})
        justOneInputFlag=1;
        e=y; y=x; x=1:num2Plot;
    else
        justOneInputFlag=0;
        e=varargin{1}(:)';
    end
else % not text arguments, not even separate 'x' argument
    e=y; y=x; x=1:length(e);
    justOneInputFlag=0;
end

hold on; % axis is already cleared if hold was off
%% Check that your vectors are the proper length
if num2Plot~=length(e) || num2Plot~=length(y)
    error('your data must be vectors of all the same length')
end

%% Check that the errors are all positive
signCheck=min(0,min(e(:)));
if signCheck<0
    error('your error values must be greater than zero')
end

%% In case you don't specify color:
color2Plot = [ 0 0 0];
% set all the colors for each plot to be the same one ... hope you like black
for kk=1:num2Plot
    lineStyleOrder{kk}=color2Plot;
end

%% Initialize some things before accepting user parameters
horizontalFlag=0;
topFlag=0;
pointsFlag=0;
barFactor=1;
linewidth=2;
colormapper='jet';
multicolorFlag=0;
fillFlag=0;

%% User entered parameters
%  if there is just one input, then start at 1,
%  but if X and Y were passed then we need to start at 2
k = 1 + 1 - justOneInputFlag; %
% 
while k <= length(varargin) && ischar(varargin{k})
    switch (lower(varargin{k}))
      case 'horizontal'
        horizontalFlag=1;
        if justOneInputFlag % need to switch x and y now
            x=y; y=1:num2Plot; % e is the same
        end
      case 'color' %
        color2Plot = varargin{k + 1};
%       set all the colors for each plot to be the same one
        for kk=1:num2Plot
            lineStyleOrder{kk}=color2Plot;
        end
        k = k + 1;
      case 'linewidth'
        linewidth = varargin{k + 1};
        k = k + 1;
      case {'barwidth','width','thickness'} 
        barFactor = varargin{k + 1};
%         barWidthFlag=1;
        k = k + 1;
      case 'points'
        pointsFlag=1;
      case 'multicolor'
          multicolorFlag=1;
      case 'colormap' % used only if multicolor
        colormapper = varargin{k+1};
        k = k + 1;
      case 'top'
          topFlag=1;
        case 'fill'
            fillFlag=1;
      otherwise
        warning('Dude, you put in the wrong argument');
    end
    k = k + 1;
end


if ~fillFlag % plot errobars normally.

if multicolorFlag
    lineStyleOrder=linspecer(num2Plot,colormapper);
end

%% Set the bar's width if not set earlier
if num2Plot==1
%   defaultBarFactor=how much of the screen the default bar will take up if
%   there is only one number to work with.
    defaultBarFactor=20;
    p=axis;
    if horizontalFlag
        barWidth=barFactor*(p(4)-p(3))/defaultBarFactor;
    else
        barWidth=barFactor*(p(2)-p(1))/defaultBarFactor;
    end
else % is more than one datum
    if horizontalFlag
        barWidth=barFactor*(y(2)-y(1))/4;
    else
        barWidth=barFactor*(x(2)-x(1))/4;
    end
end

%% Plot the bars
for k=1:num2Plot
    if horizontalFlag
        ex=e(k);
        esy=barWidth/2;
%       the main line
        if ~topFlag || x(k)>=0  %also plot the bottom half.
            h(end+1) = plot([x(k)+ex x(k)],[y(k) y(k)],'color',lineStyleOrder{k},'linewidth',linewidth);
    %       the hat     
            h(end+1) = plot([x(k)+ex x(k)+ex],[y(k)+esy y(k)-esy],'color',lineStyleOrder{k},'linewidth',linewidth);
        end
        if ~topFlag || x(k)<0  %also plot the bottom half.
            h(end+1) = plot([x(k) x(k)-ex],[y(k) y(k)],'color',lineStyleOrder{k},'linewidth',linewidth);
            h(end+1) = plot([x(k)-ex x(k)-ex],[y(k)+esy y(k)-esy],'color',lineStyleOrder{k},'linewidth',linewidth);
            %rest?
        end
    else %plot then vertically
        ey=e(k);
        esx=barWidth/2;
%         the main line
        if ~topFlag || y(k)>=0 %also plot the bottom half.
            h(end+1) = plot([x(k) x(k)],[y(k)+ey y(k)],'color',lineStyleOrder{k},'linewidth',linewidth);
    %       the hat
            h(end+1) = plot([x(k)+esx x(k)-esx],[y(k)+ey y(k)+ey],'color',lineStyleOrder{k},'linewidth',linewidth);
        end
        if ~topFlag || y(k)<0 %also plot the bottom half.
            h(end+1) = plot([x(k) x(k)],[y(k) y(k)-ey],'color',lineStyleOrder{k},'linewidth',linewidth);
            h(end+1) = plot([x(k)+esx x(k)-esx],[y(k)-ey y(k)-ey],'color',lineStyleOrder{k},'linewidth',linewidth);
        end
    end
end
%
%% plot the points, very simple

if pointsFlag
    for k=1:num2Plot
        h(end+1) = plot(x(k),y(k),'o','markersize',8,'color',lineStyleOrder{k},'MarkerFaceColor',lineStyleOrder{k});
    end
end

else % plot error bars by filling them in.
    
%     Plot the mean:
    plot(x,y,'linewidth',2,'color',color2Plot);
%     Make the polygon:

    xPoly = [x  fliplr(x) x(1)];
    yPoly = [y+e fliplr(y-e) y(1)+e(1)];
    
    h(end+1) = plot(xPoly,yPoly,'color',color2Plot)
    hReg = fill(xPoly,yPoly,color2Plot); % draw region
    set(get(get(hReg,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    
end % fillFlag check over

for hLoop = 1:length(h)
    set(get(get(h(hLoop),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
end


drawnow;
% return the hold state of the figure
if ~hold_state
    hold off;
end

end



function addPValueToPlot(x, y, pValue)
if pValue < 0.0001
    text(x, y, '****', 'FontSize', 30)
elseif pValue < 0.001
    text(x, y, '***', 'FontSize', 30)
elseif pValue < 0.01
    text(x, y, '**', 'FontSize', 30)
elseif pValue < 0.05
    text(x, y, '*', 'FontSize', 30)
% else
%     text(x, y, 'ns', 'FontSize', 12)
end
end
