classdef NirsProbeListView < View.ModelList    
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
    % Date: 2017-04-27 12:47:27
    % Packaged: 2017-04-27 17:58:55
    methods
        function obj = NirsProbeListView(id,model_list,scroll_alg)
            obj@View.ModelList(id,model_list,'title','Probe Sets');
            obj.scroll_alg = scroll_alg;
        end
    end
    
    properties(Access = 'protected')
        scroll_alg;
    end
    
    methods(Access = 'protected')
        function appendTodo(obj,p)
            p.updateOutput();
            obj.createProbeViews(p);
            p.updateOutput();
        end
        
        function removeTodo(obj,p)
%             obj.scroll_alg.removeElement([p.id '.setview']);
            obj.scroll_alg.deleteElement([p.id '.setview']);
            v = obj.controller.views.entry([p.id '.view']);
            v.deleteChildren();
            v.unsubscribe();
        end
        
        function createProbeViews(obj,p)
            axh = obj.controller.views.entry('head_view').axh;
            probe_view = NirsPlaner.ProbeView([p.id '.view'],p.id,'nirs_marker_sytle',axh);
            obj.controller.subscribeView(probe_view);
            probe_view.show();
            
            probe_setview = View.ModelInputs([p.id '.setview'],p,'title',[p.id ' Settings']);
            probe_setview.show();
            obj.controller.subscribeView(probe_setview);
%             sp.setProperty('scroll_size',sp.getProperty('scroll_size')+[0 250]);
            obj.scroll_alg.appendElement(probe_setview.id,probe_setview);
        end
    end
end