classdef ModelInputs < View.UiComposite & PropertyObject    
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
    % Date: 2017-03-21 13:43:39
    % Packaged: 2017-04-27 17:58:31
    properties(SetAccess = 'protected')
        title_alg;
    end
    
    properties(Access = 'protected')
        parent;
        model;
        view_properties;
    end
    
    methods
        function obj = ModelInputs(id,model,varargin)
            obj@View.UiComposite(id);
            obj.model = model;
            obj.view_properties = containers.Map();
            
            obj.addProperty(Input.Options('orientation',{1 2}));
            obj.addProperty(Input.StringCell('input_selection',{}));
            obj.addProperty(Input.String('title',''));
            
            obj.setProperties(varargin{:});
        end
        
        function setViewProperties(obj,input_name,varargin)
            obj.view_properties(input_name) = varargin;
        end
        
        function updateSelf(obj)
        end
    end

    methods(Access = 'protected')
        function builtUi(obj)
            title = obj.getProperty('title');
            orientation = obj.getProperty('orientation');
            input_selection = obj.getProperty('input_selection');
            
            a = MatrixAlignment(obj.h);
            if ~isempty(title)
                obj.title_alg = MatrixAlignment(obj.h);
                title = strrep(title,'_','\_');
                txt = UiText(obj.h,title,'FontWeight','bold'); txt.show();
                obj.title_alg.addElement(1,1,txt);
                a.addElement(1,1,obj.title_alg);
                offset_i = 1;
            else
                offset_i = 0;
            end
            it = Iter(ifel(isempty(input_selection),obj.model.state.entry('input').ids,input_selection));
            inputs = obj.model.state.entry('input');
            for n = it
                in = inputs.entry(n);
                v = obj.model.makeInputView([obj.id '.' in.id],in.id);
                obj.add(v);
                if any(strcmp(n,obj.view_properties.keys))
                    props = obj.view_properties(n);
                    v.setProperties(props{:});
                end
                v.show();
                vidx = ifel(orientation == 1,{it.i+offset_i,1},{1 it.i+offset_i});
                a.addElement(vidx{:},v);
            end
            if orientation == 1
                a.heights = 40*ones(1,it.n+1);
            else
                a.heights = 40;
            end
            a.realign();
            
            set(obj.h,'Units','Pixels');
            height = sum(a.heights);
            obj.setProperty('height',height);
            p = get(obj.h,'Position');
            p(4) = height;
            set(obj.h,'Position',p);
        end
        
        function composeUi(obj)
        end
        
        function updateUiElements(obj)
        end
    end
end