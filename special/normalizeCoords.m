function vxs_norm = normalizeCoords(snmat_fname,vxs)

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
    % Date: 2014-09-30 14:09:12
    % Packaged: 2017-04-27 17:58:37
load(snmat_fname);
tmp_dir = tempname;
makeDir(tmp_dir);

V = VF;
V.fname = [tmp_dir filesep 'origin.img'];
mni2vx = V.mat^-1;
affine_mat = VG.mat*inv(Affine)/VF.mat;

vxs_norm = zeros(size(vxs));

for i = 1:size(vxs,1)
    i
    [vximg,v] = createEmptyMrVolume(V);
    p = valueat(round(mni2vx*[vxs(i,:) 1]'),1:3);
    sph = voxel2index(adaptvoxel(createVoxelSphere(p',5),V.dim),V.dim);
    vximg(sph) = v;
    spm_write_vol(V,vximg);
    Vsn = spm_write_sn(V,snmat_fname);
    Vsn.dat(isnan(Vsn.dat)) = 0;
    found_i = find(Vsn.dat);
    if isempty(found_i)
        vxs_norm(i,:) = valueat(affine_mat*[vxs(i,:) 1]',1:3)';
    else
        p_norm = mean(index2voxel(found_i,Vsn.dim),1);
        vxs_norm(i,:) = valueat(Vsn.mat*[p_norm 1]',1:3);
    end
end