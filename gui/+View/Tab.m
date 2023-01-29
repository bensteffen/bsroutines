classdef Tab < View.UiItem
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
    % Date: 2016-03-22 18:30:52
    % Packaged: 2017-04-27 17:58:32
    properties(SetAccess = 'protected')
        tabmodel;
        tabh;
        ctxmenu;
        selall;
        seluns;
        selrev;
        row_select_mode;
    end
    
    methods
        function obj = Tab(id,tabmodel)
            obj@View.UiItem(id);
            obj.models.add(tabmodel);
            obj.tabmodel = tabmodel;
        end
        
        function update(obj)
            if obj.tabmodel.stateOk('display_data')
                disp_data = obj.tabmodel.getState('display_data');
                edit_cols = obj.tabmodel.getState('column_editable');
                col_names = ifel(obj.tabmodel.stateOk('column_names'),obj.tabmodel.getState('column_names'),{});
                if obj.row_select_mode
                    row_selection = obj.tabmodel.getState('display_row_selection');
                    disp_data = [row_selection(:,1) disp_data];
                    edit_cols = [true edit_cols];
                    if ~isempty(col_names), col_names = [{''} col_names]; end
                end
                set(obj.tabh,'Data',disp_data);
                set(obj.tabh,'ColumnEditable',edit_cols);
                if ~isempty(col_names), set(obj.tabh,'ColumnName',col_names); end
            end
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.builtContextMenu();
            obj.tabh = uitable('UIcontextmenu',obj.ctxmenu,'Units','normalized','CellEditCallback',@obj.cellEdit);
            
            if obj.tabmodel.stateOk('id_selection_column')
                obj.row_select_mode = obj.tabmodel.getState('id_selection_column');
                a = MatrixAlignment(obj.h);
                a.addElement(1,1,obj.tabh);
                obj.selall = uicontrol('String','Select all','Callback',@obj.pushSelection);
                obj.seluns = uicontrol('String','Unselect all','Callback',@obj.pushSelection);
                obj.selrev = uicontrol('String','Reverse selection','Callback',@obj.pushSelection);
                b = GuiAlignment(1,a.h);
                b.add(obj.selall);
                b.add(obj.seluns);
                b.add(obj.selrev);
                a.addElement(2,1,b);
                a.heights = [1 40];
                a.realign();
            else
                obj.row_select_mode = 0;
                set(obj.tabh,'Parent',obj.h);
            end
        end
        
        function pushSelection(obj,h,evd)
            switch h
                case obj.selall
                    obj.tabmodel.rowSelection('select_all_visible');
                case obj.seluns
                    obj.tabmodel.rowSelection('unselect_all_visible');
                case obj.selrev
                    obj.tabmodel.rowSelection('reverse_selection');
            end
        end
        
        function cellEdit(obj,h,evd)
            edit_data.row = evd.Indices(1);
            edit_data.col = evd.Indices(2);
            edit_data.val = evd.EditData;
            
            tab = get(obj.tabh,'Data');
            if obj.row_select_mode
                if edit_data.col == 1
                    obj.tabmodel.rowSelection('select',tab{edit_data.row,obj.row_select_mode+1},evd.EditData);
                else
                    edit_data.col = edit_data.col - 1;
                    obj.tabmodel.sendSignal('was_edited',edit_data);
                end
            else
                obj.tabmodel.sendSignal('was_edited',edit_data);
            end
        end
        
        function builtContextMenu(obj)
            obj.ctxmenu = uicontextmenu();
            sortitem = uimenu(obj.ctxmenu, 'Label', 'sort','Callback',@contextCallback);
            filteritem = uimenu(obj.ctxmenu, 'Label', 'filter','Callback',@contextCallback);
            clfilteritem = uimenu(obj.ctxmenu, 'Label', 'clear filter','Callback',@contextCallback);
            
            function contextCallback(h,evd)
                if h == clfilteritem
                    obj.tabmodel.setInput('filter',@(x) true);
                    obj.tabmodel.updateOutput();
                else
                    col_names = obj.tabmodel.getState('column_names');
                    dlgfig = plainfig('Position',[get(gcf,'CurrentPoint') 200 200] + [1 1 0 0].*get(gcf,'Position'));
                    a = GuiAlignment(2,dlgfig);
                    lh = uicontrol('Style','listbox','String',col_names);
                    ph = uicontrol('Style','pushbutton','String','OK');
                    ch = uicontrol('Style','pushbutton','String','cancel','Callback',@closeCallback);
                    switch h
                        case sortitem
                            a.add(uicontrol('Style','text','String','Select column to sort:'));
                            a.add(lh);
                            set(ph,'Callback',@sortCallback);
                            r = [1 4 1];
                        case filteritem
                            a.add(uicontrol('Style','text','String','Select column...'));
                            a.add(lh);
                            set(ph,'Callback',@filterCallback);
                            a.add(uicontrol('Style','text','String','... to filter with:'));
                            fch = uicontrol('Style','edit');
                            a.add(fch);
                            r = [1 4 1 1 1];
                    end
                    b = GuiAlignment(1,a.h); b.add(ph); b.add(ch);
                    a.add(b);
                    a.realign(r);
                end
                
                function closeCallback(h,evd)
                    close(dlgfig);
                end
                
                function sortCallback(h,evd)
                    obj.tabmodel.setInput('sort_column',get(lh,'Value'));
                    obj.tabmodel.updateOutput();
                    closeCallback();
                end
                
                function filterCallback(h,evd)
                    c = get(lh,'Value');
                    obj.tabmodel.setInput('filter_column',c);
                    fin = get(fch,'String');
                    cf = obj.tabmodel.getState('column_format');
                    switch cf{c}
                        case 'char'
                            obj.tabmodel.setInput('filter',@(x) ~isempty(regexp(x,fin)));
                        otherwise
                            obj.tabmodel.setInput('filter',eval(fin));
                    end
                    obj.tabmodel.updateOutput();
                    closeCallback();
                end
            end
        end
        
        function updateUiElements(obj)
        end
    end
end