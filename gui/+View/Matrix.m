classdef Matrix < View.UiItem & View.Abstract
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
    % Date: 2016-11-02 14:00:03
    % Packaged: 2017-04-27 17:58:31
    properties
        text_options = containers.Map({'FontSize','FontWeight'},{16,'bold'},'UniformValues',false);
        row_text_options = containers.Map({'Rotation','HorizontalAlignment'},{90,'center'},'UniformValues',false);
        col_text_options = containers.Map({'HorizontalAlignment'},{'center'},'UniformValues',false);
        label_size = 50;
        row_label_size;
        col_label_size;
    end
    
    properties(SetAccess = 'protected')
        parent;
        main;
        row_names;
        col_names;
        legend;
        alignment;
        total_alignment;
        row_txt;
        col_txt;
    end
    
    methods
        function obj = Matrix(id,parent)
            obj@View.UiItem(id);
            if nargin < 2
                parent = gcf;
            end
            obj.parent = parent;
        end
        
        function addElement(obj,type,element)
            switch type
                case 'col_names'
                    obj.col_txt = [];
                    for j = 1:length(element)
                        ax = axes('Visible','off','Clipping','off','NextPlot','add','XLim',[-1 1],'YLim',[-1 1]);
                        tx = text(0,0,strreplace(element{j},'_',' '));
                        txops = [map2cell(obj.text_options) map2cell(obj.col_text_options)];
                        set(tx,'Parent',ax,txops{:});
                        obj.col_txt = cat(2,obj.col_txt,tx);
                        obj.alignment.addElement(1,j+1,ax,[obj.label_size 1]);
                    end
                case 'row_names'
                    obj.row_txt = [];
                    for i = 1:length(element)
                        ax = axes('Visible','off','Clipping','off','NextPlot','add','XLim',[-1 1],'YLim',[-1 1]);
                        tx = text(0,0,strreplace(element{i},'_',' '));
                        txops = [map2cell(obj.text_options) map2cell(obj.row_text_options)];
                        set(tx,'Parent',ax,txops{:});
                        obj.row_txt = cat(1,obj.row_txt,tx);
                        obj.alignment.addElement(i+1,1,ax,[1 obj.label_size]);
                    end
                case 'main'
                    [nrows,ncols] = size(element);
                    for i = 1:nrows
                        for j = 1:ncols
                            obj.alignment.addElement(i+1,j+1,element(i,j));
                        end
                    end
                    %                     obj.main = obj.alignment.children;
                    obj.main = element;
                    obj.alignment.widths = [obj.label_size ones(1,ncols)/ncols];
                    obj.alignment.heights = [obj.label_size ones(1,nrows)/nrows];
                case 'legend'
                    obj.total_alignment.addElement(2,1,element);
                    obj.total_alignment.heights = [1 100];
                    obj.total_alignment.realign();
            end
        end
        
        function update(obj)
            txops = [map2cell(obj.text_options) map2cell(obj.row_text_options)];
            for t = Iter(obj.row_txt)
                set(t,txops{:});
            end
            if ~isempty(obj.row_label_size)
                obj.alignment.widths(1) = obj.row_label_size;
            end
            txops = [map2cell(obj.text_options) map2cell(obj.col_text_options)];
            for t = Iter(obj.col_txt)
                set(t,txops{:});
            end
            if ~isempty(obj.col_label_size)
                obj.alignment.heights(1) = obj.col_label_size;
            end
            obj.alignment.realign();
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.alignment = MatrixAlignment(obj.parent);
            set(obj.alignment.h,'BackgroundColor','w');
            
            obj.total_alignment = MatrixAlignment(obj.parent);
            obj.h = obj.total_alignment.h;
            obj.total_alignment.addElement(1,1,obj.alignment);
        end
        
        function updateUiElements(obj)
        end
    end
end