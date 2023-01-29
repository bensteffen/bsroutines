function patch_struct = parcelPatch(parcel_struct,parcel_id)

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
    % Date: 2016-09-15 11:18:02
    % Packaged: 2017-04-27 17:57:56
parcel_xyz = parcel_struct.xyz(parcel_struct.area == parcel_id,:);
patch_struct = voxel2patch(round(parcel_xyz),3);
patch_struct = scalePatch(patch_struct,1.05);

patch_struct.FaceLighting = 'phong';
patch_struct.EdgeLighting = 'none';
patch_struct.BackFaceLighting = 'reverselit';
patch_struct.AmbientStrength = 0.3;
patch_struct.DiffuseStrength = 0.8;
patch_struct.SpecularStrength = 0;
patch_struct.SpecularExponent = 10;
patch_struct.SpecularColorReflectance = 1;