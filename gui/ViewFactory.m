classdef ViewFactory < handle
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
    % Date: 2017-03-08 11:22:21
    % Packaged: 2017-04-27 17:58:26
    properties(SetAccess = 'protected')
        specific_input_views;
        specific_view;
        model;
    end
    
    methods
        function obj = ViewFactory(model)
            if nargin > 0
                obj.setModel(model);
            end
             obj.specific_input_views = IdList();
        end
        
        function setModel(obj,model)
            if isa(model,'Model.Abstract')
                obj.model = model;
            else
                error('ViewFactory.setModel(): model must be a Model.Abstract');
            end
        end
        
        function view = makeInputView(obj,id,intput_name,varargin)
            if ~obj.specific_input_views.hasEntry(intput_name)
                input_item = obj.model.state.entry('input').entry(intput_name);
                input_class = class(input_item);
                if exist(strjoin({'View',input_class},'.'),'class')
                    input_class = strsplit(input_class,'.');
                    view = View.Input.(input_class{end})(id,obj.model,intput_name,varargin{:});
                else
                    view = View.Input.Edit(id,obj.model,intput_name,varargin{:});
                end
            else                
                view_constr = obj.specific_input_views.valueOf(intput_name);
                view = view_constr(id,varargin{:});
            end
        end
        
        function view = makeModelView(obj,id,varargin)
            if isempty(obj.specific_view)
                class_name = strsplit(class(obj),'.');
                if exist(['View.' class_name{end}],'class')
                    view = View.(class_name{end})(id,varargin{:});
                else
                    view = View.ModelInputs(id,obj.model,varargin{:});
                end
            else
                view = obj.specific_view(id,varargin{:});
            end
        end
        
        function addInputView(obj,input_name,view_constr)
            obj.specific_input_views.add(IdItem(input_name,view_constr));
        end
        
        function setDefaultView(obj,view_constr)
            obj.specific_view = view_constr;
        end
    end
end