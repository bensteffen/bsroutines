classdef Tab < Model.Item
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
    % Date: 2016-03-22 18:16:20
    % Packaged: 2017-04-27 17:58:29
    properties(Access = 'protected')
        sort_i;
        filter_ok;
    end
    
    methods
        function obj = Tab(id)
            obj@Model.Item(id);
            
            n = Input.ElementItem('column_names',{''},{''} ...
                ,Input.Test(@iscellstr ...
                ,'Column names must be a string cell') ...
                );
            cf = Input.ElementItem('column_format',{''},{''} ...
                ,Input.Test(@iscellstr ...
                ,'Column format must be a string cell') ...
                );
            ce = Input.ElementItem('column_editable',logical([]),logical([]) ...
                ,Input.Test(@islogical ...
                ,'Column editable must be a logical vector') ...
                );
            t = Input.ElementItem('table_data',{},{} ...
                ,Input.Test(@iscell ...
                ,'Table data must be a cell') ...
                );
            fc = Input.ElementItem('filter_column',[],1 ...
                ,Input.Test(@(x) isscalar(x) && x > 0 ...
                ,'Filter column must be a scalar > 0') ...
                );
            f = Input.ElementItem('filter',@(x) true,@(x) true ...
                ,Input.Test(@isfunction ...
                ,'Filter must be a function handle') ...
                );
            sc = Input.ElementItem('sort_column',[],1 ...
                ,Input.Test(@(x) isscalar(x) && x > 0 ...
                ,'Sort column must be a scalar > 0') ...
                );
            s = Input.ElementItem('sorter',@sortall,@sortall ...
                ,Input.Test(@isfunction ...
                ,'Sorter must be a function handle') ...
                );
            e = Input.ElementItem('edit_data',struct,struct ...
                ,Input.Test(@isstruct ...
                ,'Sorter must be a function handle') ...
                );
            idsel = Input.ElementItem('id_selection_column',[],1 ...
                ... ,Input.Test(@(x) isnumscalar(x) && x > 0 && x <= size(obj.getState('table_data'),1) ...
                ,Input.Test(@(x) true ...
                ,'ID selection column must be a > 0 and <= row number') ...
                );
            t.addInput(n ,Input.Test(@(x,y) length(x) <= size(obj.getState('table_data'),2),'Number of column names must be == column number'),obj);
            t.addInput(cf ,Input.Test(@(x,y) length(x) <= size(obj.getState('table_data'),2),'Length column formats must be == column number'),obj);
            t.addInput(ce ,Input.Test(@(x,y) length(x) == size(obj.getState('table_data'),2),'Length column editable must be == column number'),obj);
            t.addInput(fc,Input.Test(@(x,y) x <= size(obj.getState('table_data'),2),'Filter column must be <= column number'),obj);
            t.addInput(sc,Input.Test(@(x,y) x <= size(obj.getState('table_data'),2),'Sort column must be <= column number'),obj);
            obj.addInput(n);
            obj.addInput(cf);
            obj.addInput(ce);
            obj.addInput(t);
            obj.addInput(fc);
            obj.addInput(f);
            obj.addInput(s);
            obj.addInput(sc);
            obj.addInput(e);
            obj.addInput(idsel);
            
            obj.addOutput(Output.ElementItem('display_data',{}));
            obj.addOutput(Output.ElementItem('row_selection',{}));
            obj.addOutput(Output.ElementItem('display_row_selection',{}));
            obj.setDefault('sorter');
            
            obj.addSignal(StateSignal('was_edited'));
        end
        
        function rowSelection(obj,type,ids,val)
            row_selection = obj.getState('row_selection');
            if strend(type,'visible'), row_sel = obj.sort_i(obj.filter_ok); end
            switch type
                case 'select'
                    ids = ifel(iscell(ids),ids,{ids});
                    row_selection = obj.getState('row_selection');
                    it = Iter(ids);
                    for id = it
                        i = cellfun(@(x) isequal(x,id),row_selection(:,2));
                        if any(i), row_selection{i,1} = val(it.i); end
                    end
                case 'select_all'
                    row_selection(:,1) = nonunicfun(@(x) true,row_selection(:,1));
                case 'select_all_visible'
                    row_selection(row_sel,1) = nonunicfun(@(x) true,row_selection(row_sel,1));
                case 'unselect_all'
                    row_selection(:,1) = nonunicfun(@(x) false,row_selection(:,1));
                case 'unselect_all_visible'
                    row_selection(row_sel,1) = nonunicfun(@(x) false,row_selection(row_sel,1));
                case 'reverse_selection'
                    row_selection(:,1) = nonunicfun(@(x) ~x,row_selection(:,1));
                case 'reverse_selection_visible'
                    row_selection(row_sel,1) = nonunicfun(@(x) ~x,row_selection(row_sel,1));
            end
            obj.setOutput('row_selection',row_selection);
            obj.updateOutput();
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            if obj.isActive('was_edited')
                edit_data = obj.state.entry('signals').entry('was_edited').value;
                i = edit_data.row; 
                ex = ~obj.filter_ok;
                i = i + sum(ex(1:i));
                i = obj.sort_i(i);
                tab = obj.getState('table_data');  
                tab{i,edit_data.col} = edit_data.val;
                obj.setInput('table_data',tab);
            end
            obj.createTabOutput();
            if obj.stateOk('id_selection_column')
                obj.createSelectOutput();
            end
        end
        
        function createTabOutput(obj)
            if obj.stateOk('table_data')
                tab = obj.getState('table_data');
                if obj.stateOk('sort_column')
                    sorter = obj.getState('sorter');
                    obj.sort_i = sorter(tab(:,obj.getState('sort_column')));
                else
                    obj.sort_i = 1:size(tab,1);
                end
                vtab = tab(obj.sort_i,:);
                if obj.stateOk('filter_column') && obj.stateOk('filter')
                    obj.filter_ok = cellfun(obj.getState('filter'),vtab(:,obj.getState('filter_column')));
                    vtab = vtab(obj.filter_ok,:);
                else
                    obj.filter_ok = true(size(tab,1),1);
                end
                obj.setOutput('display_data',vtab);
                if obj.stateOk('edit_data')
                    ed = obj.getState('edit_data');
                    for i = 1:length(ed)
                        tab{obj.sort_i(ed(i).Indices(1)),ed(i).Indices(2)} = ed(i).EditData;
                    end
                    obj.setInput('table_data',tab);
                    obj.setUnset('edit_data');
                end
            end
        end
        
        function createSelectOutput(obj)
            if obj.stateOk('table_data')
                tab = obj.getState('table_data');
                new_selection = [num2cell(false(size(tab,1),1)) tab(:,obj.getState('id_selection_column'))];
                row_selection = obj.getState('row_selection');
                if isempty(row_selection) || obj.stateChanged('table_data')
                    row_selection = new_selection;
                end
                last_selected = row_selection(cell2mat(row_selection(:,1)),:);
                for v = Iter(last_selected(:,2))
                    new_selection{cellfun(@(x) isequal(x,v),new_selection(:,2)),1} = true;
                end
                disp_sel = new_selection;
                disp_sel = disp_sel(obj.sort_i,:);
                disp_sel = disp_sel(obj.filter_ok,:);
                obj.setOutput('display_row_selection',disp_sel);
                obj.setOutput('row_selection',new_selection);
            end
        end
    end
end