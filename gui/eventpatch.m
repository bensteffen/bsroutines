function p = eventpatch(onsets,duration,ywin,varargin)

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
    % Date: 2017-01-06 16:53:27
    % Packaged: 2017-04-27 17:58:26
if nargin < 3
    ywin = [-1 1];
end

onsets = onsets(:);
s = size(onsets);

if numel(duration) == 1
    duration = ones(s)*duration;
end

x = [onsets onsets + duration onsets + duration onsets]';
y = repmat(ywin([1 2; 1 2]),[1 s(1)]);

p.Vertices = [x(:) y(:)];
p.Faces = repmat(1:4,[s(1) 1]) + repmat(4*(0:s(1)-1)',[1 4]);

for i = 1:2:numel(varargin)
    p.(varargin{i}) = varargin{i+1};
end