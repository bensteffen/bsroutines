function strs = strsplit(str,split_str)

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
    % Date: 2013-02-27 13:40:49
    % Packaged: 2017-04-27 17:58:19
cell_flag = ifel(iscell(str),true,false);
str = ifel(iscell(str),str,{str});

l = length(split_str);

strs = cell(size(str));
for i = 1:numel(str)
    currstr = str{i};
    stri = strfind(currstr,split_str);
    n = length(stri)+1;
    stri = [1 stri+l stri-1 length(currstr)];
    stri = reshape(stri,[n 2]);

    currstrs = cell(1,n);
    for s = 1:n
        currstrs{s} = currstr(stri(s,1):stri(s,2));
    end
    strs{i} = currstrs;
end

if ~cell_flag
    strs = strs{1};
end