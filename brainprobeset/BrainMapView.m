classdef BrainMapView < View.UiItem
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
    % Date: 2016-10-27 16:25:35
    % Packaged: 2017-04-27 17:57:53
    properties
        brain_map;
        handles;
    end
    
    methods
        function obj = BrainMapView(id,brain_map)
            obj@View.UiItem(id);
            obj.models.add(brain_map);
            obj.brain_map = brain_map;
            obj.handles = containers.Map({'brain_map','head_map'},{[],[]});
        end
        
        function update(obj)
            patch_data = obj.brain_map.getState('patch');
            map_type = obj.brain_map.getState('map_type');
            if isempty(obj.handles(map_type))
                obj.handles(map_type) = patch(patch_data,'Parent',obj.h);
            else
                set(obj.handles(map_type),'FaceVertexCData',patch_data.FaceVertexCData);
            end
        end
    end
    
    methods(Access = 'protected')
        function initShow(obj)
            obj.h = axes;%('Visible','off');
            brainlight;
        end
        
        function builtUi(obj)
            
        end
        
        function updateUiElements(obj)
        end
    end
end