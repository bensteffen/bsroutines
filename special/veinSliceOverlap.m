function ov = veinSliceOverlap(img_slice,pos)

    % vein slice:
    % 2 = surrounding tissue, 1 = vein wall, 0 = vein
    %
    % 2 2 2 2 2 2
    % 2 2 1 1 2 2
    % 2 1 0 0 1 2
    % 2 1 0 0 1 2
    % 2 2 1 1 2 2
    % 2 2 2 2 2 2
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
    % Date: 2013-04-26 14:50:56
    % Packaged: 2017-04-27 17:58:38


% vein_slice = [1 1 1 0 0 1 1 0 0 1 1 1]';
vein_slice = [1 1 1 1]';
ov = NaN(vxn(pos),1);
for n = 1:vxn(pos)
    i0 = pos(n,1);
    j0 = pos(n,2);

    % vein_coords =  [i0   j0
    %                 i0+1 j0
    %                 i0-1 j0+1
    %                 i0   j0+1
    %                 i0+1 j0+1
    %                 i0+2 j0+1
    %                 i0-1 j0+2
    %                 i0   j0+2
    %                 i0+1 j0+2
    %                 i0+2 j0+2
    %                 i0   j0+3
    %                 i0+1 j0+3];

    vein_coords = [i0   j0
                   i0+1 j0
                   i0   j0+1
                   i0+1 j0+1];
    
    if all(voxeltest(vein_coords,size(img_slice)))
        img_vals = img_slice(voxel2index(vein_coords,size(img_slice)));
%         img_vals = normValue(img_vals,minmax(img_vals));

        ov(n) = norm(img_vals-vein_slice);
    end
end