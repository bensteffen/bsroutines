classdef Ui < HandleInterface & PropertyObject
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
    % Date: 2017-03-13 13:00:49
    % Packaged: 2017-04-27 17:58:25
    methods
        function show(obj)
            obj.initShow();
            obj.builtUi();
            if obj.getProperty('show_close_button')
                set(obj.close_button,'Visible','on','Parent',obj.h);
                obj.showCloseButton();
            end
            obj.updateUi();
        end
        
        function deleteChildren(obj)
            
        end
        
        function deleteUi(obj,varargin)
            obj.deletion_running = true;
            obj.deleteToDo();
%             delete(get(obj.h,'Children'));
            delete(obj.close_button);
%             set(obj.h,'DeleteFcn',@(h_,evd_) 0);
            delete(obj.h);
        end
        
        function appendDeleteToDo(obj,del_fcnh)
            if isfunction(del_fcnh)
                obj.delete_todos.append(del_fcnh);
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = Ui(varargin)
            obj.addProperty(Input.Vector('height',0));
            obj.addProperty(Input.Boolean('show_close_button',false));
            obj.setProperties(varargin{:});
            obj.delete_todos = List();
        end
        
        function initShow(obj)
            obj.deletion_running = false;
            obj.h = uipanel('Units','normalized','BorderType','none','DeleteFcn',@obj.deleteUi);
            obj.close_button = uicontrol('String','X','Visible','off','Callback',@obj.deleteUi);
        end
        
        function updateUi(obj)
        end
        
        function updateUiElements(obj)
        end
        
        function showCloseButton(obj)
            
        end
        
        function deleteToDo(obj,varargin)
            for del_todo = Iter(obj.delete_todos)
                del_todo(obj);
            end
        end
    end

    methods(Access = 'protected',Abstract = true)
        builtUi(obj);
    end
    
    properties(Access = 'protected')
        close_button;
        delete_todos;
        deletion_running;
    end
end