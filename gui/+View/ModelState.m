classdef ModelState < View.UiComposite
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
    % Date: 2017-02-23 15:28:11
    % Packaged: 2017-04-27 17:58:31
    properties
        orientation = 1;
        state_selection = {};
        title = '';
    end
    
    properties(SetAccess = 'protected')
        height = 0;
    end
    
    properties(Access = 'protected')
        parent;
        model;
    end
    
    methods
        function obj = ModelState(model,title)
            obj@View.UiComposite([model.id '.input_view']);
            obj.subscribeModel(model);
            obj.model = model;
            if nargin > 1
                obj.title = title;
            end
        end
        
        function updateSelf(obj)
        end
    end

    methods(Access = 'protected')
        function builtUi(obj)
            a = MatrixAlignment(obj.h);
            if ~isempty(obj.title)
                txt = UiText(obj.h,obj.title,'FontWeight','bold'); txt.show();
                a.addElement(1,1,txt);
                offset_i = 1;
            else
                offset_i = 0;
            end
            
            if isempty(obj.state_selection)
                obj.state_selection = [obj.model.state.entry('input').ids; obj.model.state.entry('output').ids];
            end
            it = Iter(obj.state_selection);
            for n = it
                state_item = obj.model.getStateItem(n);
                v = obj.model.createView(state_item.id);
                obj.subscribeView(v);
                v.show();
                vidx = ifel(obj.orientation == 1,{it.i+offset_i,1},{1 it.i+offset_i});
                a.addElement(vidx{:},v);
            end
            if obj.orientation == 1
                a.heights = 40*ones(1,it.n+1);
            else
                a.heights = 40;
            end
            a.realign();
            
            set(obj.h,'Units','Pixels');
            obj.height = sum(a.heights);
            p = get(obj.h,'Position');
            p(4) = obj.height;
            set(obj.h,'Position',p);
        end
        
        function composeUi(obj)
        end
        
        function updateUiElements(obj)
        end
    end
end