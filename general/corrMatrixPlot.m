function varargout = corrMatrixPlot(db,rows,cols,varargin)

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
    % Date: 2017-03-14 16:24:39
    % Packaged: 2017-04-27 17:58:05
[I,J] = db.iter(rows,cols);
[r,p] = deal(zeros(I.n,J.n));
for i = I
    for j = J
        x = db.getData(j);
        y = db.getData(i);
        g = (1:numel(x))';
        [r(I.i,J.i),p(I.i,J.i)] = corrgroup(g,x,g,y,varargin{:});
    end
end

% clim = max(abs( r(:) )) .*[-1 1];
% clim = [0 max(-log10( p(:) ))];
% 
% % cls = getColorList(r(:),createColormap([0 0 1; 1 1 1; 1 0 0],5),clim);
% p_plot = p;
% p_plot(p_plot > 0.1) = 1;
% cls = getColorList(-log10(p_plot(:)) .* sign(r(:)),createColormap([0 0 1; 1 1 1; 1 0 0],5),[-3 3]);
lbs = createStatTable([r(:) p(:)]);

pranges = {[0.05 1],[0.01 0.05],[0.001 0.01],[0 0.001]};
pval2index = @(p) find(cellfun(@(rng) withinrange(p,rng,']]'),pranges)) - 1;
cls = createColormap2([0 0 1; 1 1 1; 1 0 0],7);

axs = objectmx([I.n,J.n],'uipanel','BorderType','line');
for i = 1:numel(r)
    color_i = sign(r(i))*pval2index(p(i)) + 4;
    set(axs(i),'BackgroundColor',cls(color_i,:));
    t = UiText(axs(i),lbs{i}); t.show();
    set(t.txth,'Color',ones(1,3)*(1-color_i/7),'FontWeight','bold');
end

mxv = View.Matrix('mxv');
mxv.show();
mxv.addElement('row_names',db.indices.select(rows{:}).simplify().asCellList());
mxv.addElement('col_names',db.indices.select(cols{:}).simplify().asCellList());
mxv.addElement('main',axs);
mxv.row_label_size = 150;
mxv.row_text_options('Rotation') = 0;
mxv.update();

if nargout > 0
    varargout{1} = mxv;
end