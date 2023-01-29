function [nii_patch,nii_grav] = nii2patch(nii_path,varargin)

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
    % Date: 2015-10-06 16:35:23
    % Packaged: 2017-04-27 17:57:56
fprintf('Reading NIFTI... ');
nii = readNifti(nii_path);
fprintf('Done!\n');


fprintf('Creating Patch... ');
nii.xyz = volume2voxel(nii.img);
nii.xyz = transformCoordList(nii.xyz,nii.hdr.mat);
nii.xyz = unique(round(nii.xyz),'rows');
nii_patch = voxel2patch(nii.xyz);
fprintf('Done!\n');

[nii_patch.vertices,~,ic] = unique(round(nii_patch.vertices),'rows','stable');
nii_patch.faces = ic(nii_patch.faces);

nii_patch.FaceLighting = 'phong';
nii_patch.EdgeColor = 'none';
nii_patch.SpecularColorReflectance = 0;
nii_patch.SpecularExponent = 5;
nii_patch.SpecularStrength = 0.2000;
nii_patch.FaceColor = [0.6 0.6 0.6];

nii_grav = mean(nii_patch.vertices);

for j = 1:2:numel(varargin)
    nii_patch.(varargin{j}) = varargin{j+1};
end