classdef Color < View.Input.AbstractComposite
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
    % Date: 2017-03-08 11:13:29
    % Packaged: 2017-04-27 17:58:33
    properties(Access = 'protected')
        color_patches;
        selection_figh;
%         push;
    end

    methods
        function obj = Color(id,model,input_name,varargin)
            obj@View.Input.AbstractComposite(id,model,input_name);
            
            selectable_colors = [1 0 0; 0 0 1; 0 1 0; 1 0 0.8; 0 0 0];
            obj.addProperty(Input.Colors('selectable_colors',selectable_colors));
            obj.addProperty(Input.Vector('color_matrix_size',[1 size(selectable_colors,1)],2));
            obj.setProperties(varargin{:});
        end
    end
    
    methods(Access = 'protected')
        function valueCallback(obj,varargin)
            delete(obj.color_patches);
            obj.color_patches = [];
            
            mpos = get(0,'PointerLocation');
            obj.selection_figh = plainfig('Position',[mpos 300 50],'CloseRequestFcn',@obj.colorCallback);
            select_alg = MatrixAlignment(obj.selection_figh);
            push_close = uicontrol('String','X','Callback',@obj.colorCallback);
            select_alg.addElement(1,1,push_close);
            axh = axes('Parent',obj.selection_figh,'Units','normalized','Position',[0 0 1 1],'Visible','off');
            select_alg.addElement(1,2,axh);
            select_alg.widths = [20 1];
            select_alg.realign();
            
            selectable_colors = obj.getProperty('selectable_colors');
            mxs = obj.getProperty('color_matrix_size');
            for c = 1:size(selectable_colors,1)
                ij = index2voxel(c,mxs);
                p = eventpatch(ij(2),1,[0 1]+ij(1),'FaceColor',selectable_colors(c,:),'EdgeColor','none','Parent',axh,'ButtonDownFcn',@obj.colorCallback);
                obj.color_patches = [obj.color_patches;patch(p)];
            end
%             obj.sendCommand(Command.SetInput(obj,obj.models.lastEntry(),obj.input_name,n,true));
        end
        
        function colorCallback(obj,h,varargin)
            if any(h == obj.color_patches)
                selected_color = get(h,'FaceColor');
                if ~isempty(selected_color)
                    obj.sendCommand(Command.SetInput(obj,obj.models.lastEntry(),obj.input_name,selected_color,true));
                end
            end
            delete(obj.selection_figh);
        end
        
        function composeUi(obj)
            edit = View.Input.Edit([obj.id '.edit'],obj.model,obj.input_name,'style',0);
            obj.add(edit);
            edit.show();
%             obj.push = uicontrol('String','','Callback',@obj.valueCallback,'BackgroundColor',obj.inputValue());
%             obj.value_alg.add(obj.push);
%             obj.value_alg.add(edit.h);
            
            push = View.ColorField([obj.id '.push'],obj.model,obj.input_name,'style',0);
            obj.add(push);
            push.show();
            set(push.valueh,'Callback',@obj.valueCallback);
            
            obj.value_alg.add(push.h);
            obj.value_alg.add(edit.h);
        end
        
        function updateUiElements(obj)
        end
    end
end