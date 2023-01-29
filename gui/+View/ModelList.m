classdef ModelList < View.UiItem
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
    % Date: 2017-04-27 13:05:03
    % Packaged: 2017-04-27 17:58:31
    properties(SetAccess = 'protected')
        model_list;
        appended_models;
        model_factories;
        model_list_alg;
        lbox;
        factory_lbox;
        id_input;
    end
    
    methods
        function obj = ModelList(id,model_list,varargin)
            obj@View.UiItem(id);
            obj.addProperty(Input.String('title',''));
            obj.setProperties(varargin{:});
            obj.models.add(model_list);
            obj.model_list = model_list;
            obj.model_factories = IdList();
            obj.appended_models = IdList();
        end
        
        function update(obj)
            mids = obj.model_list.ids;
            if isempty(mids)
                v = [];
            else
                v = get(obj.lbox,'Value');
                v = ifel(isempty(v),1,v);
                v = min(v,numel(mids));
                v = max(1,v);
            end
            set(obj.lbox,'String',mids,'Value',v);
            for m = Iter(obj.model_list)
                if ~obj.appended_models.hasEntry(m.id)
                    obj.appended_models.add(m);
                    obj.appendTodo(m);
                end
            end
        end
        
        function addFactory(obj,factory_id,model_factory)
            if isa(model_factory,'ModelFactory')
                obj.model_factories.add(IdItem(factory_id,model_factory));
            end
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            a = MatrixAlignment(obj.h);
            title = obj.getProperty('title');
            ph = 20;
            if ~isempty(title)
                txt = UiText(obj.h,title,'FontWeight','bold'); txt.show();
                a.addElement(1,1,txt,[ph 1]);
                offset = 1;
            else
                offset = 0;
            end
            
            obj.lbox = uicontrol('Parent',obj.h,'Style','listbox','String',obj.model_list.ids,'Callback',@obj.listCallback);
            a.addElement(1+offset,1,obj.lbox);
            
            push_alg = MatrixAlignment(gcf);
            push_alg.addElement(1,1,uicontrol('Parent',obj.h,'String','Add','Callback',@obj.addModel),[ph 1]);
            push_alg.addElement(1,2,uicontrol('Parent',obj.h,'String','Remove','Callback',@obj.removeModel),[ph 1]);
            push_alg.addElement(2,1,uicontrol('Parent',obj.h,'String','Up','Callback',@obj.moveUp),[ph 1]);
            push_alg.addElement(2,2,uicontrol('Parent',obj.h,'String','Down','Callback',@obj.moveDown),[ph 1]);
            push_alg.addElement(3,1,uicontrol('Parent',obj.h,'String','Load','Callback',@obj.loadModels),[ph 1]);
            push_alg.addElement(3,2,uicontrol('Parent',obj.h,'String','Save','Callback',@obj.saveModels),[ph 1]);
            push_alg.addElement(4,1,uicontrol('Parent',obj.h,'String','Copy','Callback',@obj.copyModel),[ph 1]);
            a.addElement(2+offset,1,push_alg,[push_alg.children_size(1)*ph 1]);
            
%             a.heights = [1 40 40];
%             a.realign();
            obj.model_list_alg = a;
            
            obj.modifyUi();
        end
        
        function updateUiElements(obj)
        end
        
        function addModel(obj,h,evd)
            fh = plainfig('WindowStyle','modal','Position',[get(0,'PointerLocation')-[75 0] 300 200]);
            
            obj.factory_lbox = uicontrol('Style','listbox','String',obj.model_factories.ids);
            txt = UiText(fh,'ID:'); txt.show();
            obj.id_input = uicontrol('Style','edit');
            ok = uicontrol('String','Ok','Callback',@obj.addModelCallback);
            
            alg = MatrixAlignment(fh);
            alg.addElement(1,1,obj.factory_lbox);
            
            alg2 = MatrixAlignment(fh);
            alg2.addElement(1,1,txt);
            alg2.addElement(1,2,obj.id_input);
            
            alg.addElement(2,1,alg2,[40 1]);
            alg.addElement(3,1,ok,[40 1]);
        end
        
        function removeModel(obj,h,evd)
            l = get(obj.lbox,'String');
            vals = get(obj.lbox,'Value');
            if all(withinrange(vals,[1 length(l)],'[]',true))
                for i = vals
                    id = l{i};
                    m = obj.model_list.entry(id);
                    obj.removeTodo(m);
                    obj.appended_models.remove(m.id);
                    obj.model_list.removeModel(id);
                end
                l(vals) = [];
                set(obj.lbox,'Value',1,'String',l);
                obj.update();
            end
        end
        
        function moveUp(obj,varargin)
            obj.model_list.moveUp(obj.selectedModel());
            obj.update();
            set(obj.lbox,'Value',max(get(obj.lbox,'Value')-1,1));
        end
        
        function moveDown(obj,varargin)
            obj.model_list.moveDown(obj.selectedModel());
            obj.update();
            set(obj.lbox,'Value',min(get(obj.lbox,'Value')+1,obj.model_list.length));
        end
        
        function loadModels(obj,varargin)
            fname = uigetfile('*.mat');
            if fname ~= 0
                obj.model_list.loadModels(fname);
            end
        end
        
        function saveModels(obj,varargin)
            fname = uiputfile(['prepro-' datestr(now,29) '.mat']);
            if ~isempty(fname)
                obj.model_list.saveModels(fname);
            end
        end
        
        function copyModel(obj,varargin)
            mid = obj.selectedModel();
            m0 = obj.model_list.entry(mid);
            copy_id = inputdlg('ID:','',1,{mid}); copy_id = copy_id{1};
            if ~isempty(copy_id)
                m = m0.copy(copy_id);
                obj.model_list.appendModel(m);
                obj.appendTodo(m);
                obj.update();
            end
        end
        
        function appendTodo(obj,m)

        end
        
        function removeTodo(obj,m)
            
        end
        
        function clickModel(obj,m)
            
        end
        
        function openModel(obj,m)
            
        end
        
        function addModelCallback(obj,varargin)
            fids = get(obj.factory_lbox,'String');
            fid = fids{get(obj.factory_lbox,'Value')};
            model_id = get(obj.id_input,'String');
            close(gcf);
            if ~isempty(model_id)
                m = obj.model_factories.valueOf(fid).makeModel(model_id);
                obj.model_list.appendModel(m);
                obj.update();
            end
        end
        
        function listCallback(obj,varargin)
            mid = obj.selectedModel();
            if ~isempty(mid)
                m = obj.model_list.entry(mid);
                switch get(gcf,'SelectionType')
                    case 'normal'
                        obj.clickModel(m);
                    case 'open'
                        obj.openModel(m);
                end
            end
        end
        
        function mid = selectedModel(obj)
            mid = {};
            ids = get(obj.lbox,'String');
            if ~isempty(ids)
                mid = ids{get(obj.lbox,'Value')};
            end
        end
        
        function modifyUi(obj)
        end
    end
end