function X = completeChannelInterpolation(X,chs2interp,probeset_matrix,opt_distance,general_interp)

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
    % Date: 2015-01-22 14:51:15
    % Packaged: 2017-04-27 17:58:46
if nargin < 5
    general_interp = [];
end

chs2interp = [chs2interp general_interp];
chs2interp = [chs2interp find(any(isnan(X)))];
chs2interp = [chs2interp find(isconstant(X))];
chs2interp = unique(chs2interp);

if ~isempty(chs2interp)
    X = NAfilt.gaussianNirsInterp(X,probeset_matrix,chs2interp,opt_distance);
end