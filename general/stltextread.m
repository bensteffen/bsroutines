function verts = stltextread(stl_fname)

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
    % Date: 2014-12-19 18:42:16
    % Packaged: 2017-04-27 17:58:19
fid = fopen(stl_fname);
    fc = textscan(fid,'%s');
fclose(fid);
fc = fc{1};

[~,vert_lines] = strcellextract(fc,'vertex');
vert_lines = find(vert_lines);

verts = zeros(length(vert_lines),3);
verts(:,1) = cell2mat(cellfun(@str2double,fc(vert_lines+1),'UniformOutput',false));
verts(:,2) = cell2mat(cellfun(@str2double,fc(vert_lines+2),'UniformOutput',false));
verts(:,3) = cell2mat(cellfun(@str2double,fc(vert_lines+3),'UniformOutput',false));

% verts(:,1) = cell2mat(vert_lines());