function map2d(vals,chmatrix,varargin)

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
    % Date: 2015-03-05 11:36:51
    % Packaged: 2017-04-27 17:57:55
param_defaults.color_map = jet(64);
param_defaults.color_limit = minmax(vals);
param_defaults.show_probeset = false;
param_defaults.significance = 0;
param_defaults.axes_handle = [];
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

axes_handle = ifel(isempty(axes_handle),gca,axes_handle);
vals = vals(:);
opthalf = 15;
ij2xy = @(i_,j_) floor([(i_-1)*opthalf + opthalf/2 (j_-1)*opthalf + opthalf/2]);
dim = size(chmatrix);

i_ok = ~isnan(vals);
xy = zeros(0,2);
for k = find(i_ok)'
    [i,j] = find(chmatrix == k);
    xy = [xy; ij2xy(i,j)];
end

ni = opthalf*dim(1);
nj = opthalf*dim(2);

X = [];
for j = 1:size(xy,1)
    X = [X; createVoxelSphere(xy(j,:),20)];
end
X = unique(X,'rows');
X = X(voxeltest(X,[ni nj]),:);

shape = zeros(ni,nj);
shape(voxel2index(X,[ni nj])) = 1;
shapesm = smooth2(shape,10);
shapesm(shapesm < 0.1) = 0;
X = volume2voxel(shapesm);
shapesm(shape > 1) = 1;

yint = interpolateRbf(X,xy,vals(i_ok),@(r) exp(-(r/opthalf).^2));
yint = scale2interval(yint,minmax(vals(i_ok)));

X = voxel2index(X,[ni nj]);
mx = NaN(ni,nj);
mx(X) = yint;

imagesc(mx,'Parent',axes_handle);
% imagesc(mx,'Parent',axes_handle,'AlphaData',shapesm); 
set(axes_handle,'YLim',[1 ni],'XLim',[1 nj],...
                'XTick',[],'Ytick',[],...
                'DataAspectRatio',[1 1 1]);
axis(axes_handle,'ij');
caxis(axes_handle,color_limit);
set(gcf,'ColorMap',color_map);
% set(axes_handle,);

if show_probeset
    chs = chmatrix(~isnan(chmatrix));
    for k = chs(:)'
        [i,j] = find(chmatrix == k);
        xy = ij2xy(i,j) - 0.5;
        if any(k == significance)
            str = sprintf('\\textbf{%d$^*$}',k);
        else
            str = sprintf('\\textbf{%d}',k);
        end
        
        text(xy(2),xy(1),str,'Interpreter','latex','FontSize',16,'Parent',axes_handle);
    end
end