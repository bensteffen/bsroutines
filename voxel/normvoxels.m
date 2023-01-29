function [vxs,s,varargout] = normvoxels(vxs,vxsize,varargin)

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
    % Date: 2014-07-11 10:09:06
    % Packaged: 2017-04-27 17:58:41
o = min(vxs,[],1);
vxs = vxs - repmat(o,[vxn(vxs) 1]);

vxs = floor(vxs ./ repmat(vxsize,[vxn(vxs) 1])) + 1;
s = max(vxs);

if nargout > 2
    varargout = cell(1,length(varargin));
    for i = length(varargin)
        v = varargin{i};
        v = v - repmat(o,[vxn(v) 1]);
        v = floor(v ./ repmat(vxsize,[vxn(v) 1])) + 1;
        varargout{i} = v;
    end
end