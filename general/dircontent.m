function dir_content = dircontent(dir_name,name_filter,dir_flag,fullfile_flag)

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
    % Date: 2017-04-03 15:37:03
    % Packaged: 2017-04-27 17:58:07
if nargin < 2
    name_filter = '*';
end
if nargin < 3
    dir_flag = 'all';
end
if nargin < 4
    fullfile_flag = '';
end
    

dir_content = dir(fullfile(dir_name,name_filter));
dir_content = struct2cell(dir_content);
dir_content = dir_content(1,:)';
dir_content(strcmp(dir_content,'.') | strcmp(dir_content,'..')) = [];

if ~strcmp(dir_flag,'all')
    dir_vec = cellfun(@(x) isdir(fullfile(dir_name,x)),dir_content);
    switch dir_flag
        case 'files'
            dir_content(dir_vec) = [];
        case 'dirs'
            dir_content(~dir_vec) = [];
    end
end

if strcmp(fullfile_flag,'fullfile')
    dir_content = fullfile(dir_name,dir_content);
end