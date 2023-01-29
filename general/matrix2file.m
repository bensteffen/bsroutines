%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 25-Jan-2012 14:50:25

function matrix2file(M, fname, precision, separator, header, open_type)

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
    % Date: 2012-01-25 15:45:26
    % Packaged: 2017-04-27 17:58:13
I = size(M,1);
J = size(M,2);

if nargin == 2
    precision = 4;
    separator = '\t';
    header = '';
    open_type = 'w';    
elseif nargin == 3
    separator = '\t';
    header = '';
    open_type = 'w';
elseif nargin == 4
    header = '';
    open_type = 'w';
elseif nargin == 5
    open_type = 'w';
end

[p n e] = fileparts(fname);
if ~isempty(p) && ~isdir(p)
    mkdir(p);
end

if isempty(e)
    fname = fullfile(p,[n '.txt']);
end

precision_string = num2str(precision);
format_string = ['%.' precision_string 'f'];

file_h = fopen(fname,open_type);

    if ~isempty(header)
        fprintf(file_h, header); fprintf(file_h,'\r\n');
    end
    
    if ischar(M)
        fprintf(file_h, M);
    elseif iscellstr(M)
        for i = 1:I
            for j = 1:J
                fprintf(file_h,M{i,j});
                if j == J
                    fprintf(file_h,'\r\n');
                else
                    fprintf(file_h,separator);
                end
            end
        end        
    elseif isnumeric(M)
        for i = 1:I
            for j = 1:J
                fprintf(file_h, format_string, M(i,j));
                if j == J
                    fprintf(file_h,'\r\n');
                else
                    fprintf(file_h,separator);
                end
            end
        end
    end
fclose(file_h);