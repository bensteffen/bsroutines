classdef Pipeline < View.ModelList
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
    % Date: 2017-03-15 19:18:23
    % Packaged: 2017-04-27 17:58:31
    methods
        function obj = Pipeline(id,model_list,varargin)
            obj@View.ModelList(id,model_list,'title','Process Pipeline',varargin{:});
        end
    end
    
    methods(Access = 'protected')
        function appendTodo(obj,m)
%             mv = makeProcessorView(obj,p);
%             i = obj.model_list_alg.children_size(1) + 1;
%             obj.model_list_alg.addElement(i,1,mv);
        end
        
        function v = showProcessorView(obj,id,p)
            v = p.makeView(id);
            v.show();
            obj.controller.subscribeView(v);
        end
        
        function openModel(obj,m)
            vid = ['pipeline.attached.' m.id];
            if ~obj.controller.views.hasEntry(vid)
                mv = showProcessorView(obj,vid,m);
                mv.appendDeleteToDo(@(x) obj.view_alg.removeElement(mv.id));
                obj.view_alg.appendElement(mv.id,mv,mv.getProperty('height'));
            end
        end
        
        function modifyUi(obj)
            n = obj.model_list_alg.children_size(1);
            
            run_push = uicontrol('String','Run all','Callback',@obj.runAll);
            obj.model_list_alg.addElement(n+1,1,run_push,[40 1]);
            
            waitbar = View.Waitbar('process_status_view');
            obj.controller.subscribeView(waitbar);
            waitbar.show();
            obj.model_list_alg.addElement(n+2,1,waitbar,[40 1]);
            
            alg = MatrixAlignment(obj.h);
            alg.addElement(1,1,obj.model_list_alg);
            
            obj.view_alg = ListScrolling('pipeline.scrollpanel',obj.controller);
            alg.addElement(2,1,obj.view_alg.h.h.h);
            
%             alg.heights = [240 1];
%             alg.realign();
        end
        
        function runAll(obj,varargin)
            obj.model_list.updateOutput();
        end
    end
    
    properties(Access = 'protected')
        view_alg;
    end
end