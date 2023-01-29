function varargout = showMarkers(markers,surface_patch)

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
    % Date: 2016-09-16 00:00:01
    % Packaged: 2017-04-27 17:57:56
if nargin < 2
    ax = gca;
else
    figure;
    patch(surface_patch);
    ax = gca;
    brainlight;
end

set(ax,'DataAspectRatio',[1 1 1]);
m = cell2mat(markers.values');
h = writeNumberOnBrain(m,repmat({'O'},[size(m,1) 1]),'axes_handle',ax,'surface_offset',0);


if nargout > 0
    varargout = {h};
end