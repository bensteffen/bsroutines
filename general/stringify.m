function str = stringify(v,n)

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
    % Date: 2017-03-07 15:36:21
    % Packaged: 2017-04-27 17:58:19
if nargin < 2
    n = 6;
end

if isnumeric(v)
    str = mat2str(v,n);
elseif iscell(v);
    strmat = cellfun(@(x) stringify(x,n),v,'UniformOutput',false);
    str = cell(size(strmat,1),1);
    for i = 1:size(strmat,1)
        str{i} = cell2str(strmat(i,:),' ');
    end
    str = sprintf('{%s}',cell2str(str,'; '));
elseif ischar(v)
    str = sprintf('''%s''',v);
elseif isfunction(v)
    str = func2str(v);
elseif isa(v,'Id')
    str = v.id;
elseif isa(v,'Data.Index')
    str = v.asString();
else
%     str = sprintf('< %s >',class(v));
    error('stringify does not support input of type %s',class(v));
end