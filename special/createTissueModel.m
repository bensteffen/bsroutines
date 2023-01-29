function createTissueModel(seg_fnames,sm_kernel)

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
    % Date: 2016-10-19 16:54:06
    % Packaged: 2017-04-27 17:58:35
if nargin < 2
    sm_kernel = 0;
end

hdr = spm_vol(seg_fnames{1});
seg_size = hdr.dim;
voxel_number = prod(seg_size);

[p,n] = fileparts(seg_fnames{1});
% tissue_fname.hdr = [fullfile(p,['t' n(3:end)]), '.hdr'];
% tissue_fname.img = [fullfile(p,['t' n(3:end)]) '.img'];

tissue_fname = [fullfile(p,['t' n(3:end)]) '.nii'];

matter_order = [4 5 3 2 1] + 1;
prob_maps = zeros(voxel_number,6,'single');
fprintf('Creating tissue model... ');
ps = ProgressStatus(5);
for i = 1:5
    hdr = spm_vol(seg_fnames{i});
    img = single(spm_read_vols(hdr));
    prob_maps(:,matter_order(i)) = img(:);
    ps.update(i);
end
ps.finish('Done!\n');
clear img

prob_maps(:,1) = 1 - sum(prob_maps,2);
[~, matter_model] = max(prob_maps, [], 2);

matter_model = int32(reshape(matter_model - 1,seg_size));

fprintf('Writing tissue model... ');
% hdr.fname = tissue_fname.img;
hdr.fname = tissue_fname;
hdr.dt(1) = spm_type('int32');
hdr.fname
spm_write_vol(hdr,matter_model);
fprintf('Done!\n');


if sm_kernel ~= 0
    s = SpmSmooth();
%     s.setProperty('data',{strreplace(tissue_fname.img,'\','\\')});
    s.setProperty('data',{strreplace(tissue_fname,'\','\\')});
    s.setProperty('fwhm',sm_kernel);
    
    b = SpmBatch();
    b.add(s);
    b.run();

%     movefile(addPrefix(tissue_fname.hdr,'s'),tissue_fname.hdr);
%     movefile(addPrefix(tissue_fname.img,'s'),tissue_fname.img);
    movefile(addPrefix(tissue_fname,'s'),tissue_fname);
end