classdef BrainFrame < Model.FrameCreator
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
    % Date: 2014-11-11 17:24:39
    % Packaged: 2017-04-27 17:57:53
    properties
        brain_map;
        ax;
    end
    
    methods
        function obj = BrainFrame()
            obj@Model.FrameCreator('frame_creator');
            obj.brain_map = BrainMap('frame_brain_map');
            obj.ax = gca;
            set(obj.ax,'Visible','off');
            light('Position',[1/sqrt(2) 1/sqrt(2) 0],'Style','infinite','Parent',obj.ax);
            light('Position',[1/sqrt(2) -1/sqrt(2) 0],'Style','infinite','Parent',obj.ax);
            light('Position',[-1 0 0],'Style','infinite','Parent',obj.ax);
            
            obj.addInput(Input.ElementItem('view_angles',[],[0 90],Input.Test(@(x) isnumeric(x) && length(x) == 2,'View angles must be a vector with 2 elements')));
            obj.setDefault('view_angles');
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            obj.brain_map.setInput('values',obj.getState('frame_data'));
            obj.brain_map.updateOutput();
            obj.setOutput('frame_handle',obj.ax);
            if obj.stateChanged('view_angles')
                set(obj.ax,'View',obj.getState('view_angles'));
            end
        end
    end
end