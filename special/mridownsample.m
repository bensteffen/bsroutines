function img1 = mridownsample(hdr0,hdr1,downsample_fcn)

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
    % Date: 2014-04-14 17:55:21
    % Packaged: 2017-04-27 17:58:37
if nargin < 3
    downsample_fcn = @mean;
end

img0 = spm_read_vols(hdr0);
img1 = zeros(prod(hdr1.dim),1);

[vxs0,img0] = volume2voxel(img0);

vxs1 = transformCoordList(vxs0,hdr0.mat);
vxs1 = round(transformCoordList(vxs1,hdr1.mat^-1));
ioob = ~voxeltest(vxs1,hdr1.dim);
vxs1(ioob,:) = [];
vxs0(ioob,:) = [];
img0(ioob) = [];

vxs1 = voxel2index(vxs1,hdr1.dim);

vxs1unq = unique(vxs1);

fprintf('Downsampling... ');
ps = ProgressStatus(length(vxs1unq));
for i = 1:length(vxs1unq)
    vals = img0(vxs1 == vxs1unq(i));
    img1(vxs1unq(i)) = downsample_fcn(vals);
    ps.update(i);
end
ps.finish('Done!\n');