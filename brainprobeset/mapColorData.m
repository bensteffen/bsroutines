function color_data = mapColorData(pdata,mapdata)

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
    % Date: 2017-02-09 15:03:25
    % Packaged: 2017-04-27 17:57:55
d = 20;

[Xall,yint_all,i_patch_all,color_data] = deal([]);
for p = 1:length(mapdata)
    i_ok = ~isnan(mapdata(p).val);

    i_patch = voxelarea(pdata.vertices,mapdata(p).xyz(i_ok,:),d);
    X = pdata.vertices(i_patch,:);
    
    i_patch_all = cat(1,i_patch_all,i_patch);
    
    if ~isempty(X)
        yint = interpolateRbf(X,mapdata(p).xyz(i_ok,:),mapdata(p).val(i_ok),@(r) exp(-(r/d).^2));
        yint_all = [yint_all; yint];
        Xall = [Xall; X];
    end
    
    color_data = cat(1,color_data,[find(i_patch) yint]);
end

% if ~isempty(Xall)
%     color_data = [find(i_patch_all) yint_all];
% end