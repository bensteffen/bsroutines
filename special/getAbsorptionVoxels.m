function absorb_voxels = getAbsorptionVoxels(subject_number,matter_vec,exp_name)

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
    % Date: 2012-02-24 14:29:04
    % Packaged: 2017-04-27 17:58:35
absorb_voxels = cell(1,24);
for j = 1:24
    C = volume2voxelList(loadEpiAbsorption(subject_number,j,exp_name,1));
    C = extractMatterVoxels(C,loadEpiAnatomie(subject_number, exp_name),matter_vec);
    absorb_voxels{j} = voxel2listIndex(C,[64 64 24]);
end