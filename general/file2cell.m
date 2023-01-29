function content = file2cell(fname,header_lines)

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
    % Date: 2014-09-30 16:45:56
    % Packaged: 2017-04-27 17:58:08
if nargin < 2
    header_lines = 0;
end

flines = cell(0,1);
fid = fopen(fname);
    l = 0;
    while ~feof(fid)
        l = l + 1;
        flines{l} = fgetl(fid);
    end
fclose(fid);

flines = flines(header_lines+1:end);
l = length(flines);

coln = zeros(l,1);
for i = 1:l
    delimiter = findDelimiter(flines{i});
    flines{i} = strsplit(flines{i},sprintf(delimiter));
    coln(i) = length(flines{i});
end

content = cell(l,max(coln));
for i = 1:l
    content(i,1:length(flines{i})) = flines{i};
end

for i = 1:numel(content)
    if ischar(content{i})
        if isempty(content{i})
            content{i} = [];
        else
            v = str2num(content{i});
            if ~isempty(v)
                content{i} = v;
            end
        end
    end
end