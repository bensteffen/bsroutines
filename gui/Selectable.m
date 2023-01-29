classdef Selectable < handle
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
    % Date: 2017-02-24 14:41:04
    % Packaged: 2017-04-27 17:58:24
    properties(SetAccess = 'protected')
        selection_model;
        select_id;
        selectable_handles;
        selection_data;
        is_selected;
        last_selected;
        string_creator;
    end
    
    methods
        function updateSelection(obj)
            selected_id = obj.selection_model.getState('selected_id');
            selection_type = obj.selection_model.getState('selection_type');
%             obj.selection_model.selection_observers.ids
            was_selected = strcmp(selected_id,obj.select_id);
            current_handle_i = obj.selectable_handles == obj.selection_data.handle;
            switch selection_type
                case 'normal'
                    if was_selected
                        obj.setSelection(false,~current_handle_i);
                        obj.setSelection(~obj.is_selected(current_handle_i),current_handle_i);
                    else
                        obj.setSelection(false,true(size(obj.selectable_handles)));
                    end
                case 'alt'
                    if obj.is_selected(current_handle_i)
                        obj.setSelection(~was_selected,current_handle_i);
                    else
                        obj.setSelection(was_selected,current_handle_i);
                    end
                case 'extend'
                    if was_selected
                        current_handle_f = find(current_handle_i);
                        obj.last_selected = ifel(isempty(obj.last_selected),current_handle_f,find(obj.last_selected));
                        i_range = sort([current_handle_f obj.last_selected]);
                        i_range = i_range(1):i_range(2);
                        s = false(size(obj.selectable_handles));
                        s(i_range) = true;
                        obj.setSelection(true,s);
                        obj.setSelection(false,~s);
                    else
                        obj.setSelection(false,true(size(obj.selectable_handles)));
                    end
                case 'open'
                    if was_selected
                        obj.open;
                    end
            end
            obj.last_selected = current_handle_i;
        end
        
        function setSelectionModel(obj,selection_model)
            obj.selection_model = selection_model;
        end
        
        function setStringCreator(obj,string_creator)
            if isa(string_creator,'SelectionStringCreator')
                string_creator = string_creator.setSelectable(obj);
                obj.string_creator = string_creator;
            end
        end
        
        function s = getSelectionString(obj,flag)
            if nargin < 2
                flag = true;
            end
            s = obj.string_creator.createString(flag);
        end
    end
    
    methods(Abstract = true,Access = 'protected')
        highlight(obj,flag);
        open(obj);
    end
    
    methods(Access = 'protected')
        function obj = Selectable(id)
            obj.select_id = id;
            obj.selection_data = struct;
            obj.setSelectionModel(Model.Empty('selection'));
            obj.defineSelectableHandles(obj);
            obj.selection_data.handle = obj.selectable_handles(1);
            obj.string_creator = SelectionStringCreator(obj);
        end
        
        function defineSelectableHandles(obj,handles)
            obj.selectable_handles = handles;
            obj.is_selected = false(1,length(handles));
        end
        
        function selectionCallback(obj,varargin)
            obj.selection_data.handle = varargin{1};
            obj.selection_data.event_data = varargin{2};
            if ~isa(obj.selection_model,'Model.Empty');
                obj.selection_model.setInput('selected_id',obj.select_id);
                obj.selection_model.setInput('selection_type',get(obj.selection_model.getState('figure'),'SelectionType'));
                obj.selection_model.selectionUpdate();
            end
        end
    end
    
    methods(Access = 'private')
        function setSelection(obj,flag,i)
            obj.is_selected(i) = flag;
            obj.highlight(flag,i);
        end
    end
end