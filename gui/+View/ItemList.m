classdef ItemList < View.UiComposite
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
    % Date: 2016-08-04 17:03:22
    % Packaged: 2017-04-27 17:58:30
    properties(SetAccess = 'protected')
        scroll_panel;
        gui_figure;
        list_name;
        list_alignment;
        column_names;
    end
    
    methods
        function obj = ItemList(id,item_list_model,gui_figure,col_format_str)
            obj@View.UiComposite(id);
            obj.list_name = item_list_model.id;
            obj.subscribeModel(item_list_model);
            obj.gui_figure = gui_figure;
            
            obj.column_names = strsplit(col_format_str,'|');
        end
        
        function updateSelf(obj)
            
        end
        
        function addItem(obj,item)
            
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.list_alignment = MatrixAlignment();
            obj.scroll_panel = ScrollPanel([obj.list_name '.view.sroll_panel'],obj.gui_figure,obj.list_alignment);
            obj.scroll_panel.setProperty('scroll_size',[-1 0]);
        end
        
        function updateUiElements(obj)
        end
        
        function composeUi(obj)
        end
    end
end