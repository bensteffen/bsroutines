function norm_coords = native2mni(native_fname,snmat_fname,native_coords,write_results)

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
    % Date: 2016-02-04 11:21:51
    % Packaged: 2017-04-27 17:58:37
if nargin < 4
    write_results = false;
end

tmp_dir = tempname;
tmp_dir = fullfile(fileparts(tmp_dir),'native2mni');
makeDir(tmp_dir);

copyfile(native_fname,fullfile(tmp_dir,'native.nii'));
copy_fname = fullfile(tmp_dir,'native.nii');
native = readNifti(copy_fname);

maxval = max(native.img(:));
maxpossible = spm_type(native.hdr.dt(1),'maxval');
if ~(1.5*maxval < maxpossible)
    native.img = reshape(normValue(native.img(:),[0 maxpossible/1.5]),native.hdr.dim);
    markval = maxpossible;
else
    markval = 1.5*maxval;
end

load(snmat_fname);
write_flags = struct('bb',apptrans([1 1 1; native.hdr.dim],native.hdr.mat));

native_coords = round(transformCoordList(native_coords,native.hdr.mat^(-1)));
affine_mat = VG.mat* Affine^-1 * VF.mat^-1;
% affine_mat = VG.mat* VF.mat^-1;

norm_coords = zeros(size(native_coords));

ps = ProgressStatus(size(native_coords,1));
for i = 1:size(native_coords,1)
    copyfile(native_fname,fullfile(tmp_dir,'native.nii'));
    native = readNifti(copy_fname);
    marked = native;
    sph = voxel2index(adaptvoxel(createVoxelSphere(native_coords(i,:),5),marked.hdr.dim),marked.hdr.dim);
    marked.img(sph) = markval;
%     marked.hdr.fname = fullfile(tmp_dir,'marked.img');
    writeNifti(marked);
    
    Vsn = spm_write_sn(marked.hdr,snmat_fname,write_flags);
    Vsn.dat(isnan(Vsn.dat)) = 0;
%     writeNifti(Vsn);
    found_i = find(Vsn.dat > 0.9*markval);
    if isempty(found_i)
        norm_coords(i,:) = valueat(affine_mat*[native_coords(i,:) 1]',1:3)';
    else
        p_norm = mean(index2voxel(found_i,Vsn.dim),1);
        norm_coords(i,:) = p_norm;
%         norm_coords(i,:) = valueat(Vsn.mat*[p_norm 1]',1:3);
    end
    ps.update(i);
end
ps.finish('Done!\n');

if write_results
    copyfile(native_fname,fullfile(tmp_dir,'native.nii'));
    Vsn = spm_write_sn(spm_vol(copy_fname),snmat_fname,write_flags);
    Vsn.dat(isnan(Vsn.dat)) = 0;
    norm_coords_vxs = round(transformCoordList(norm_coords,Vsn.mat^(-1)));
    for i = 1:size(norm_coords,1)
        sph = voxel2index(adaptvoxel(createVoxelSphere(norm_coords_vxs(i,:),3),Vsn.dim),Vsn.dim);
        Vsn.dat(sph) = markval;
    end
    writeNifti(Vsn);
    movefile(Vsn.fname,fullfile(pwd,'wnative.nii'));
end
