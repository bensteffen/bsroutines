function matter_model = createMatterModelFromNewSegment(seg_files,matter_model_fname,sm_kernel)

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
    % Date: 2014-04-14 15:30:40
    % Packaged: 2017-04-27 17:58:35
if nargin < 3
    sm_kernel = 0;
end

hdr = spm_vol(seg_files{1});
seg_size = hdr.dim;
voxel_number = prod(seg_size);

matter_order = [4 5 3 2 1] + 1;

arr_size = 6*4*voxel_number;
mem = memory;
if arr_size > mem.MaxPossibleArrayBytes
    nrg = 10;
    rg = subdivideRange([1 voxel_number],nrg);
    matter_model = [];
    for n = 1:nrg
        r = rg(n,:)
        vxn = length(r(1):r(2));
        prob_maps = zeros(vxn,6,'single');

        for i = 1:5
            seg_files{i}
            hdr = spm_vol(seg_files{i});
            img = single(spm_read_vols(hdr));
            prob_maps(:,matter_order(i)) = img(r(1):r(2));
        end
        clear img

        prob_maps(:,1) = 1 - sum(prob_maps,2);
        [~, mm] = max(prob_maps, [], 2);
        matter_model = [matter_model; mm];
    end
else
    prob_maps = zeros(voxel_number,6,'single');

    for i = 1:5
        hdr = spm_vol(seg_files{i});
        img = single(spm_read_vols(hdr));
        prob_maps(:,matter_order(i)) = img(:);
    end
    clear img

    prob_maps(:,1) = 1 - sum(prob_maps,2);
    [~, matter_model] = max(prob_maps, [], 2);
end

matter_model = int32(reshape(matter_model - 1,seg_size));

hdr.fname = matter_model_fname;
hdr.dt(1) = spm_type('int32');
spm_write_vol(hdr,matter_model);

if sm_kernel ~= 0
    init_spm_batch;
    SPMSETS__.smooth = {'data',{matter_model_fname},'fwhm',sm_kernel};
    smooth_batch;
    run_spm_batch;

    [p,n,e] = fileparts(matter_model_fname);

    fname_hdr = fullfile(p,[n '.hdr']);
    fname_img = fullfile(p,[n '.img']);

    movefile(addPrefix(fname_hdr,'s'),fname_hdr);
    movefile(addPrefix(fname_img,'s'),fname_img);
end