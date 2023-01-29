function plotmatrix(data_base,i_selection,j_selection,plot_handle,varargin)

    % plot_handle = @(x,y,axes_handle) ...
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
    % Date: 2016-11-02 13:04:13
    % Packaged: 2017-04-27 17:58:16

[i_it,j_it] = data_base.iter(i_selection,j_selection);
axs = objectmx([i_it.n,j_it.n],'panelaxes');
for i = i_it
    for j = j_it
        y = data_base.getData(i);
        x = data_base.getData(j);
        plot_handle(x,y,axs(i_it.i,j_it.i).axh);
        set(axs(i_it.i,j_it.i).axh,varargin{:});
    end
end

mxv = View.Matrix('mxv');  mxv.show();
mxv.addElement('row_names',data_base.select(i_selection{:}).simplify().asCellList());
mxv.addElement('col_names',data_base.select(j_selection{:}).simplify().asCellList());
mxv.addElement('main',axs);