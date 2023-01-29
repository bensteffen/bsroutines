classdef DataBaseTree < Model.ViewingItem & Ui
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
    % Date: 2017-03-21 13:48:51
    % Packaged: 2017-04-27 17:58:30
    properties
        lists;
        db;
        tab;
        list_alignment;
        current_col;
        current_row;
    end
    
    methods 
        function obj = DataBaseTree(id,data_base)
            obj@Model.ViewingItem(id);
            obj.models.add(data_base);
            obj.db = data_base;
            obj.current_col = 0;
            obj.addInput(Input.ElementItem('selected_index',[],Data.Index(),Input.Test(@(x) isa(x,'Data.Index'),'Selected index must be a Data.Index')));
            obj.setDefault('selected_index');
        end
        
        function update(obj)
            obj.tab = obj.db.indices.asTable();
            s = obj.getState('selected_index');
            if obj.db.hasData(s)
                n = numel(obj.lists);
                j = obj.current_col;
                if j < n
                    c = [s.asCell() {'*'}];
                else
                    c = [s.goUp().asCell() {'*'}];
                    j = j - 1;
                end
                ilist = obj.db.indices();
                ilist.setProperty('selection_type','wildcard');
                sub_tab = ilist.select(c{:}).asTable();
                set(obj.lists(j+2:end),'Visible','off');
                if n > 0 && withinrange(j,[1 n]) && size(sub_tab,2) >= j+1
                    set(obj.lists(j+1),'String',unique(sub_tab(:,j+1)),'Visible','on');
                end
            end
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.update();
            n = size(obj.tab,2);
            
            obj.list_alignment = MatrixAlignment(obj.h);
            obj.lists = objectmx([1 n],'uicontrol','Style','listbox','Visible','off');
            for j = 1:n
                set(obj.lists(j),'Callback',@obj.listSelection);
                obj.list_alignment.addElement(1,j,obj.lists(j));
            end
            set(obj.lists(1),'Visible','on','String',unique(obj.tab(:,1)));
        end
        
        function updateUiElements(obj)

        end
        
        function createOutput(obj)
        end
        
        function listSelection(obj,list_h,varargin)
            j = find(obj.lists == list_h);
            obj.current_col = ifel(isempty(j),0,j);
            s = obj.getState('selected_index').asCell();
            if obj.current_col <= length(s)
                s = s(1:j-1);
            end
            list_content = get(list_h,'String');
            s = [s list_content(get(list_h,'Value'))];
            obj.setInput('selected_index',Data.Index(s{:}));
            obj.update();
            obj.updateOutput();
        end
        
        function updateLists(obj)

        end
    end
end