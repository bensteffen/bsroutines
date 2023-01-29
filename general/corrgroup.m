function [r,p,n,x,y] = corrgroup(ids1,values1,ids2,values2,varargin)

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
    % Date: 2017-03-13 15:58:08
    % Packaged: 2017-04-27 17:58:06
param_defaults.corr_type = 'Pearson';
param_defaults.scatter_plot = false;
param_defaults.marker_style = 'ko';
param_defaults.axes_handle = [];
param_defaults.alpha_level = 0.05;
param_defaults.xname = 'x';
param_defaults.yname = 'y';
param_defaults.exclude = [];
param_defaults.label_options = {'FontSize',12,'FontWeight','bold'};
param_defaults.xcondition = @(x) true;
param_defaults.ycondition = @(y) true;
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

[ids1,ids2,values1,values2] = deal(ids1(:),ids2(:),values1(:),values2(:));

minid = min([min(ids1) min(ids2)]);
exclude(exclude < minid) = [];

[ids1,ids2,exclude] = deal(ids1-minid+1,ids2-minid+1,exclude-minid+1);
maxid = max([max(ids1) max(ids2)]);
exclude(exclude > maxid) = [];

[x,y] = deal(NaN(maxid,1));
x(ids1) = values1;
y(ids2) = values2;

x(exclude) = [];
y(exclude) = [];

iok = arrayfun(xcondition,x) & arrayfun(ycondition,y);
% ycondition
sum(iok)
[x,y] = deal(x(iok),y(iok));

i2corr = ~isnan(x) & ~isnan(y);
[x,y] = deal(x(i2corr),y(i2corr));
n = sum(i2corr);

% [x,y]

[r,p] = corr(x,y,'type',corr_type);

if scatter_plot
    axes_handle = ifel(isempty(axes_handle),gca,axes_handle);
    axes(axes_handle);
    hold on;
    [xname,yname] = deal(strreplace(xname,'_','\_'),strreplace(yname,'_','\_'));
    xlabel(xname,label_options{:});
    ylabel(yname,label_options{:});
    title(sprintf('r = %.2f, p = %.1e, n = %d',r,p,n));

    if p <= alpha_level
        x_lim = get(axes_handle,'XLim');
        regline = getRegressionLine(x,y,minmax(x));
        plot(regline(:,1),regline(:,2),'-','LineWidth',2,'Color',[.5 .5 .5]);
    end
    plot(x,y,marker_style,'MarkerSize',6,'LineWidth',2);
end