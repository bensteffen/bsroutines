function error_tube = errortube(x,y,e,varargin)

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
    % Date: 2015-03-25 15:19:20
    % Packaged: 2017-04-27 17:58:08
[patch_prob_names,patch_probs] = parsePropertyCell(varargin);

n = size(e,1);
epm = NaN(2*n,1);
epm((0:2:2*length(e)-1) + 1) = y + e;
epm(isnan(epm)) = y - e;
x = repmat(x(:)',[2 size(x,2)]);
error_tube.vertices = [x(:) epm];

error_tube.faces = repmat(1:4,[n-1 1]) + repmat((0:2:2*(n - 2))',[1 4]);
error_tube.faces(:,3:4) = fliplr(error_tube.faces(:,3:4));
error_tube.EdgeColor = 'None';

for i = 1:length(patch_prob_names)
    error_tube.(patch_prob_names{i}) = patch_probs{i};
end