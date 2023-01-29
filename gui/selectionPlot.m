function selectionPlot(varargin)

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
    % Date: 2016-08-04 14:02:50
    % Packaged: 2017-04-27 17:58:27
f = GuiFigure();

fig_alg = MatrixAlignment(f.h);
pax = panelaxes();

y_it = Iter(varargin);
colors = lines(y_it.n);
for y = y_it
    name = inputname(y_it.i);
    
    pm = Model.PlotElement([name '.plot_model']);
    pm.setInput('xdata',1:size(y,1));
    pm.setInput('ydata',y);
    
    psm = Model.PlotElementStyle([name '.plot_style']); 
    psm.setInput('color',colors(y_it.i,:));
    psm.setInput('width',1);
    psm.updateOutput();
    
    fig_alg.addElement(1,1,pax);
end

pv = View.PlotElement(name,pm,psm,pax.axh);
pv.update();

sp = ScrollPanel('scroll_panel',f);
sp.setProperty('scroll_size',[-1 100]);
fig_alg.addElement(2,1,sp.h);
fig_alg.heights = [1 100];
fig_alg.realign();

selview = View.SelectionStrings('selection_view');

f.subscribeModel(pm);
f.subscribeModel(psm);
f.subscribeView(pv);
f.subscribeView(selview);

selview.show();
set(selview.h,'Parent',sp.scroll_panel);