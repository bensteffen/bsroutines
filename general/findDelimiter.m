function delimiter = findDelimiter(file_line,poss_delimiters)

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
    % Date: 2013-11-27 17:45:48
    % Packaged: 2017-04-27 17:58:08
if nargin < 2
    poss_delimiters = {'\t',',',';',' '};
end

n = length(poss_delimiters);
found = false(1,n);
nfound = zeros(1,n);
for i = 1:n
    pos = strfind(file_line,sprintf(poss_delimiters{i}));
    found(i) = ~isempty(pos);
    nfound(i) = length(pos);
end

if ~any(found)
    delimiter = '';
else
    del_i = find(nfound == max(nfound));
    if isscalar(del_i)
        delimiter = poss_delimiters{del_i};
    else
        delimiter = '';
    end
end