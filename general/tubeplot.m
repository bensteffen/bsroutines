function tubeplot(x,y,e,varargin)

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
    % Date: 2016-06-01 16:36:21
    % Packaged: 2017-04-27 17:58:20
param_defaults.line_color = 'k';
param_defaults.line_width = 2;
param_defaults.line_style = '-';
param_defaults.tube_alpha = 0.2;
param_defaults.axes_handle = [];
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

if isempty(axes_handle)
    axes_handle = gca;
end

patch(errortube(x,y,e,'FaceColor',line_color,'FaceAlpha',tube_alpha,'Parent',axes_handle)); hold on;
line(x,y,'Color',line_color,'LineWidth',2,'LineStyle',line_style,'Parent',axes_handle);