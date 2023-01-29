%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 20-Jan-2012 19:38:34


function [data,trigger] = readNirsData(fname)
    % fname
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
    % Date: 2015-11-10 13:12:03
    % Packaged: 2017-04-27 17:58:50
fid = fopen(fname);
    first_line = fgetl(fid);
    header_lines = 1;
    if strcmp(first_line,'Header')
        while ~strcmp(first_line,'Data')
            first_line = fgetl(fid);
            header_lines = header_lines + 1;
        end
        first_line = fgetl(fid);
        header_lines = header_lines + 1;
    end
    delimiter = findDelimiter(first_line);
    if isempty(delimiter)
        error('readNirsData: No unique delimiter found in "%s".',fname);
    end
    lineCell = textscan(first_line,'%s','Delimiter',delimiter);
    lineCell = lineCell{1};
    columnNumber = length(lineCell);
    chNumber = 0;
    formatCell = cell(1,columnNumber);
    ch_columns = [];
    for i = 1:columnNumber
        currString = lineCell{i};
        if strstart(currString,'Probe')
            formatCell{i} = '%d';
        elseif strstart(currString,'CH')
            formatCell{i} = '%n';
            chNumber = chNumber + 1;
            ch_columns(chNumber) = i;
        elseif strcmp(currString,'Mark')
            formatCell{i} = '%n';
            triggerColumn = i;
        else
            formatCell{i} = '%s';
        end
    end
    format = cell2str(formatCell,' ');
    fileContent = textscan(fid,format,'Delimiter',delimiter);
fclose(fid);

data = zeros(length(fileContent{1}),chNumber);
for j = 1:chNumber
    data(:,j) = fileContent{ch_columns(j)};
end

trigger = double(fileContent{triggerColumn});
