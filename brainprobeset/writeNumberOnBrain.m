function varargout = writeNumberOnBrain(point,num_text,varargin)


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
    % Date: 2016-10-31 14:20:38
    % Packaged: 2017-04-27 17:57:56
param_defaults.surface_offset = 9;
param_defaults.axes_handle = [];
param_defaults.text_color = 'k';
param_defaults.text_scale = 0.3;
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

if isempty(axes_handle)
    axes_handle = gca;
end
txth = zeros(size(point,1),1);
for j = 1:size(point,1)
    t = getBrainTangentials(point(j,:));

    ptext = load('textpatches.mat',['tp' num_text{j}]);
    ptext = ptext.(['tp' num_text{j}]);

    ptext.vertices = transformCoordList(ptext.vertices,createTransMat('scale',text_scale*[1 1 1],'offset',point(j,:) + surface_offset*t(:,3)','rotation',t));
    txth(j) = patch(ptext,'Parent',axes_handle);
    set(txth(j),'FaceColor',text_color,'EdgeColor',text_color,'SpecularExponent',100);
end

if nargout > 0
    varargout{1} = txth;
end