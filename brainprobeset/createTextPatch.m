function createTextPatch(t)

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
    % Date: 2012-09-07 15:31:58
    % Packaged: 2017-04-27 17:57:55
word_length = length(t);

ah = text(0,0,t,'FontSize',30); set(gca,'XLim',[-1 5*word_length],'YLim',[-1 1],'XTick',[],'YTick',[],'Visible','off')
axis xy;
saveas(ah,'tmp.bmp');
close(gcf);
data = imread('tmp.bmp');
delete('tmp.bmp');
% data = flipud(~data);
data = ~data';

vxs = index2voxel(find(data),size(data));
vxs = voxelsToOrigin(vxs) + 2;
s = findDimension(vxs);

zlength = 1;

zvxs = repmat(1:zlength,[size(vxs,1) 1]);
vxs = [repmat(vxs,[zlength 1]) zvxs(:)];

s = [s zlength] + 2;
data = zeros(s);
data(voxel2index(vxs,s)) = 1;

[x y z] = meshgrid(1:s(2),1:s(1),1:s(3));
tp = isosurface(x,y,z,data,0);
tp.vertices = tp.vertices - repmat(floor(mean(tp.vertices)),[size(tp.vertices,1) 1]);
tp_name = ['tp' t];
eval([tp_name ' = tp;']);

if exist('textpatches.mat','file')
    save('textpatches.mat',tp_name,'-append');
else
    save('textpatches.mat',tp_name);
end