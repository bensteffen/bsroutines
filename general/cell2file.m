function cell2file(fname,C,format,varargin)

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
    % Date: 2016-04-13 18:23:37
    % Packaged: 2017-04-27 17:58:05
param_defaults.line_delimiter = '\n';
param_defaults.delimiter = '\t';
param_defaults.header = '';
param_defaults.write_mode = 'overwrite';
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

[rows,columns] = size(C);

if iscell(format)
    format = format(:)';
    if length(format) ~= columns
        error('Number of columns and number length of format cell must be equal.');
    end
elseif ischar(format)
    format = repmat({format},[1 columns]);
else
    error('Format must be a string or a string cell.');
end



if ~exist(fname,'file')
    fid = fopen(fname,'w');
    fclose(fid);
end

switch write_mode
    case 'append'
        fid = fopen(fname,'a');
    case 'overwrite'
        fid = fopen(fname,'w');
    otherwise
        error('Mode must be ''append'' or ''overwrite''');
end


if ~isempty(header)
    if iscellstr(header)
        header = cell2str(header,delimiter);
    end
    fprintf(fid,header); fprintf(fid,'\n');
end

format = repmat({cell2str(format,delimiter)},[rows 1]);
format = cell2str(format,line_delimiter);
C = C';
fprintf(fid,format,C{:});

% for i = 1:rows
%     for j = 1:columns
%         fprintf(fid,format{j},C{i,j}); 
%         if ~mod(j,columns)
%             fprintf(fid,'\n');
%         else
%             fprintf(fid,delimiter);
%         end
%     end
% end

fclose(fid);

