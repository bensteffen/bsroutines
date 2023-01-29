%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 20-Jan-2012 19:38:34


function fh = createFigure(figureData)

    %
    % Disclaimer of Warranty (from http://www.gnu.org/licenses/):
    %  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
    %  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
    %  PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
    %  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    %  A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
    %  IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
    %  SERVICING, REPAIR OR CORRECTION.
    %  
    % Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
    % Date: 2012-12-18 17:03:54
    % Packaged: 2017-04-27 17:58:35
fh = figure('position', [100 100 1000 800]);

if ~isfield(figureData,'figureStyle')
    figureData.figureStyle = 'plot'
end
if ~isfield(figureData,'xzoom')
    figureData.xzoom = 1;
end
if ~isfield(figureData,'yzoom')
    figureData.yzoom = 1;
end
if ~isfield(figureData,'error')
    figureData.error = cell(length(figureData.xData),1);
else
    if length(figureData.error) < length(figureData.xData)
        figureData.error{length(figureData.xData)} = [];
    end
end


switch figureData.figureStyle
    case 'plot'
        dataNumber = length(figureData.yData);
        if isempty(figureData.lineWidth)
            for i = 1:dataNumber
                figureData.lineWidth{i} = get(gca, 'LineWidth');
            end
        end

        if isempty(figureData.markerSize)
            for i = 1:dataNumber
                figureData.markerSize{i} = 6;
            end
        end

        for i = 1:dataNumber
            hold on;
            if isempty(figureData.error{i})
                plot(figureData.xData{i}*figureData.xzoom, figureData.yData{i}*figureData.yzoom, figureData.style{i}, 'MarkerSize', figureData.markerSize{i}, 'LineWidth', figureData.lineWidth{i});
            else
                errorbar(figureData.xData{i}*figureData.xzoom, figureData.yData{i}*figureData.yzoom,figureData.error{i}*figureData.yzoom, figureData.style{i}, 'MarkerSize', figureData.markerSize{i}, 'LineWidth', figureData.lineWidth{i});
            end
        end
    case 'bar'
        h = bar(figureData.xData{1},'LineWidth',2);
        set(get(h(1),'BaseLine'),'LineWidth',2);
%         colormap gray;
    otherwise
    error('Unknown figure style %s',figureData.figureStyle)
end

if ~isempty(figureData.xLimits)
    set(gca, 'XLim', figureData.xLimits*figureData.xzoom);
end

if ~isempty(figureData.yLimits)
    set(gca, 'YLim', figureData.yLimits*figureData.yzoom);
end

if isfield(figureData, 'xTick')
    set(gca,'XTick',figureData.xTick);
end

if isfield(figureData, 'yTick')
    set(gca,'YTick',figureData.yTick);
end

if isfield(figureData,'yDigitNumber')
    tick = get(gca,'YTick');
    for l = 1:length(tick)
        fstr = ['%.' num2str(figureData.yDigitNumber) 'f'];
        yTickLabel{l} = sprintf(fstr,tick(l));
    end
    set(gca,'YTickLabel',yTickLabel);
end

if isfield(figureData,'xDigitNumber')
    tick = get(gca,'XTick');
    for l = 1:length(tick)
        fstr = ['%.' num2str(figureData.xDigitNumber) 'f'];
        xTickLabel{l} = sprintf(fstr,tick(l));
    end
    set(gca,'XTickLabel',xTickLabel);
end

if isfield(figureData,'xTickLabel')
    set(gca,'XTickLabel',figureData.xTickLabel);
end

if isfield(figureData,'yTickLabel')
    set(gca,'YTickLabel',figureData.yTickLabel);
end

box on;
set(gca, 'LineWidth', 2);
set(gca, 'FontSize', 16);
xlabel(figureData.xLabel ,'interpreter', 'Latex', 'FontSize', 24);
ylabel(figureData.yLabel ,'interpreter', 'Latex', 'FontSize', 24);
