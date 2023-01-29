classdef HeadView < Model.ViewingItem & Ui
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
    % Date: 2016-09-18 16:57:45
    % Packaged: 2017-04-27 17:58:55
    properties(SetAccess = 'protected')
        brainh;
        headh;
        axh;
        alg;
        brodmann_hdls;
        marker_hdls;
    end
    
    methods
        function obj = HeadView(id,model_name)
            obj@Model.ViewingItem(id);
            obj.models.add(Model.Empty(model_name));
            obj.addInput(Input.ScalarWithinRange('head_alpha',0.5,[0 1]));
            obj.addInput(Input.Boolean('show_markers',true));
            ba = Input.ElementItem('show_brodmann_areas',[],[] ...
                ,Input.Test(@(x) isnumeric(x) && all(isint(x(:))) && all(x(:) > 0) ...
                ,'Brodmann areas must be a vector positive integers'));
            
            obj.addInput(ba);
            obj.setDefault('head_alpha');
            obj.setDefault('show_markers');
        end
        
        function update(obj)
            hm = obj.models.lastEntry();
            if hm.statesOkAndChanged('head_patch')
                if ishandle(obj.headh)
                    delete(obj.headh)
                end
                axes(obj.axh);
                obj.headh = patch(hm.getState('head_patch'));
            end
            if hm.statesOkAndChanged('brain_patch')
                if ishandle(obj.brainh)
                    delete(obj.brainh)
                end
                axes(obj.axh);
                obj.brainh = patch(hm.getState('brain_patch'));
            end
            obj.updateOutput();
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.alg = MatrixAlignment(obj.h);
            obj.axh = axes('Units','normalized','Visible','off','DataAspectRatio',[1 1 1]); brainlight;
            obj.alg.addElement(1,1,obj.axh);
        end
        
        function createOutput(obj)
            hm = obj.models.lastEntry();
            hm_changed = hm.stateChanged('brain_patch') || hm.stateChanged('head_patch');
            
            if obj.stateChanged('head_alpha') || hm_changed
                set(obj.headh,'FaceAlpha',obj.getState('head_alpha'));
            end
            
            if obj.stateChanged('show_brodmann_areas') || hm_changed
                ba_ids = obj.getState('show_brodmann_areas');
                brodmann = hm.getState('brodmann');
                delete(obj.brodmann_hdls); obj.brodmann_hdls = [];
                for b = ba_ids
                    p = parcelPatch(brodmann,b);
                    p.FaceColor = 'g';
                    p.EdgeColor = 'none';
                    p.Parent = obj.axh;
                    obj.brodmann_hdls = cat(1,obj.brodmann_hdls,patch(p));
                end
            end
            
            if obj.stateChanged('show_markers') || hm_changed
                delete(obj.marker_hdls); obj.marker_hdls = [];
                if obj.getState('show_markers')
                    markers = hm.getState('markers');
                    m = cell2mat(markers.values');
                    obj.marker_hdls = writeNumberOnBrain(m,repmat({'O'},[size(m,1) 1]),'axes_handle',obj.axh,'surface_offset',0);
                end
            end
        end
    end
end