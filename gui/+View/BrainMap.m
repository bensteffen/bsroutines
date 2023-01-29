classdef BrainMap < View.UiItem
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
    % Date: 2016-10-27 14:48:38
    % Packaged: 2017-04-27 17:58:29
    methods
        function obj = BrainMap(id,map_model_name)
            obj@View.UiItem(id);
            obj.models.add(Model.Empty(map_model_name));
        end
        
        function update(obj)
            map_model = obj.models.lastEntry();
            if map_model.stateOk('brain_patch')
                disp patch
                patch(map_model.getState('brain_patch'),'Parent',obj.h);
            end
            if map_model.stateOk('head_patch')
                patch(map_model.getState('head_patch'),'Parent',obj.h);
            end
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.h = axes('Visible','off','DataAspectRatio',[1 1 1]);
            brainlight;
        end
        
        function updateUiElements(obj)
        end
    end
end