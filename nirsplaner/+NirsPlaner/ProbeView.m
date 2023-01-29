classdef ProbeView < View.UiItem
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
    % Date: 2017-04-25 13:02:24
    % Packaged: 2017-04-27 17:58:55
    properties(SetAccess = 'protected')
        probe_model = '';
        marker_model = '';
        marker_handles = {};
        axes_handle;
    end
    
    methods
        function obj = ProbeView(id,probe_model_name,marker_model_name,axes_handle)
            obj@View.UiItem(id);
            obj.models.add(Model.Empty(probe_model_name));
            obj.models.add(Model.Empty(marker_model_name));
            obj.probe_model = probe_model_name;
            obj.marker_model = marker_model_name;
            obj.axes_handle = axes_handle;
%             obj.appendDeleteToDo(@(x) x.deleteChildren);
        end
        
        function update(obj)
            pd = obj.models.entry(obj.probe_model).getState('probe_data');
            marker_style = obj.models.entry(obj.marker_model);
            axes(obj.h);
            obj.deleteChildren();
            if obj.models.entry(obj.probe_model).stateOk('probe_data')
                for id = Iter(fieldnames(pd))
                    if strstart(id,'CH')
                        chnum = findNumberByKeyword(id,'CH');
                        obj.marker_handles = [obj.marker_handles; {writeNumberOnBrain(pd.(id).xyz,{num2str(chnum)},'surface_offset',3)}];
                    else
                        s = regexp(id,'[0-9]+');
                        key = id(1:s-1);
                        if any(strcmp(key,marker_style.getState('marker_3d_shape').ids()))
                            markerp = marker_style.getFromState('marker_3d_shape',key);
                            if numel(pd.(id).xyz) == 3
                                obj.marker_handles = [obj.marker_handles; {patchOnBrain(pd.(id).xyz,markerp,1,2,gca)}];
                            end
                        end
                    end
                end
            end
        end
        
        function deleteChildren(obj)
            for m = Iter(obj.marker_handles)
                delete(m);
                obj.marker_handles = [];
            end
        end
    end
    
    methods(Access = 'protected')
        function initShow(obj)
            obj.h = obj.axes_handle;
        end
        
        function builtUi(obj)
            
        end
        
        function updateUiElements(obj)
        end
    end
end