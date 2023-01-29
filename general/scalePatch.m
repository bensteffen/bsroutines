function [p,ui] = scalePatch(p,f,varargin)

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
    % Date: 2016-04-06 11:18:20
    % Packaged: 2017-04-27 17:58:17
param_defaults.round_vertices = false;
param_defaults.reduce = [];
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

p.vertices = scalevoxels(p.vertices,f);

if round_vertices
    [p.vertices,ui,ic] = unique(round(p.vertices),'rows','stable');
    p.faces = ic(p.faces);
else
    ui = [];
end

if ~isempty(reduce)
    pr = reducepatch(p,reduce*size(p.vertices,1));
    p.vertices = pr.vertices;
    p.faces = pr.faces;
end