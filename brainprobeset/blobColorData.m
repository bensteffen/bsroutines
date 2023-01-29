function color_data = blobColorData(pdata,mapdata)

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
    % Date: 2016-11-16 15:58:38
    % Packaged: 2017-04-27 17:57:54
color_data = [];
for p = 1:length(mapdata)
    for j = 1:size(mapdata(p).xyz,1)
        mapdata(p).rad(j) = 15;

        if ~isnan(mapdata(p).val(j))
            i_patch = voxelarea(pdata.vertices,mapdata(p).xyz(j,:),7.5);
            i_patch = find(i_patch);
            color_data = [color_data; [i_patch repmat(mapdata(p).val(j),[length(i_patch) 1])]];
        end
    end
end