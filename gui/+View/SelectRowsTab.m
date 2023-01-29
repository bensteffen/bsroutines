classdef SelectRowsTab < View.UiComposite
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
    % Date: 2016-03-22 10:55:47
    % Packaged: 2017-04-27 17:58:31
    properties(Access = 'protected')
        tabmodel;
        tabview;
        alg;
        selall;
        seluns;
        selrev;
    end
    
    methods
        function obj = SelectRowsTab(id,tabmodel)
            obj@View.UiComposite(id);
            obj.subscribeModel(tabmodel);
            obj.tabmodel = tabmodel;
        end
        
        function updateSelf(obj)
            
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.alg = MatrixAlignment(obj.h);
            
            obj.tabview = View.Tab('tabview',obj.tabmodel.id);
            set(obj.tabview.tabh,'CellEditCallback',@obj.cellEdit);
            set(obj.tabview.tabh,'ColumnWidth',{'auto' 'auto' 200 100 'auto'});
            obj.subscribeView(obj.tabview);
            obj.tabview.show();
            
            obj.selall = uicontrol('String','Select all','Callback',@obj.pushSelection);
            obj.seluns = uicontrol('String','Unselect all','Callback',@obj.pushSelection);
            obj.selrev = uicontrol('String','Reverse selection','Callback',@obj.pushSelection);
            
            
            obj.alg.addElement(1,1,obj.tabview);
%             c = GuiAlignment(1,obj.alg.h);
%             c.add(obj.selall);
%             c.add(obj.seluns);
%             c.add(obj.selrev);
%             obj.alg.addElement(2,1,c);
%             obj.alg.addElement(3,1,expush);
%             obj.alg.heights = [1 40 40];
%             obj.alg.realign();
        end
        
        function composeUi(obj)
        end
        
        function updateUiElements(obj)
        end
        
        function cellEdit(obj,h,evd)
            row = evd.Indices(1);
            tab = get(obj.tabh,'Data');
            switch evd.Indices(2)
                case 1
                    obj.model_list.entry('etgtable').change('selection',tab{row,2},evd.EditData);
                case 3
                    obj.model_list.entry('etgtable').change('id',tab{row,2},evd.EditData);
            end
        end

        function pushSelection(obj,h,evd)
            tab = get(obj.tabh,'Data');
            switch h
                case obj.selall
                    obj.model_list.entry('etgtable').change('select_all',tab(:,2));
                case obj.seluns
                    obj.model_list.entry('etgtable').change('unselect_all',tab(:,2));
                case obj.selrev
                    obj.model_list.entry('etgtable').change('reverse_selection',tab(:,2));
            end
        end

        function pushExport(obj,h,evd)
%             ids = obj.model_list.entry('etgtable').getState('selected_ids');
            obj.model_list.entry('etgtable').sendSignal('start_export');
        end
    end
end