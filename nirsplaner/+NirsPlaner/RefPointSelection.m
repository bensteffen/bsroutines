classdef RefPointSelection < View.Composite
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
    % Date: 2016-03-15 11:02:54
    % Packaged: 2017-04-27 17:58:55
    properties(SetAccess = 'protected')
        rep_map;
        probe_list = {''};
        probe_name;
    end
    
    methods
        function obj = RefPointSelection(id,model,input_name)
            obj@View.Composite(id);
            
            load('..\brainprobeset\Colin27_10-20-Markers.mat');
            
            pd = model.getState('probe_data');
            prmap = containers.Map(fieldnames(pd),fieldnames(pd));
            
            refprobe_pop = View.MapSelection([id '_refprobe_pop'],model,'reference_probe_point','Probe point',prmap);
            refprobe_pop.setStyle('v');
            
            th = uicontrol(obj.h,'Style','text','String','on');
            refhead_pop = View.MapSelection([id '_refhead_pop'],model.id,'reference_head_point','head point',markers);
            refhead_pop.setStyle('v');
            
            alg = GuiAlignment(1,obj.h);
            alg.add(refprobe_pop);
            alg.add(th);
            alg.add(refhead_pop);
            
%             obj.add(refhead_pop);
%             obj.add(refprobe_pop);

            obj.subscribeModel(model);
            obj.subscribeView(refprobe_pop);
            obj.subscribeView(refhead_pop);
        end
        
        function updateSelf(obj)
        end
    end
end