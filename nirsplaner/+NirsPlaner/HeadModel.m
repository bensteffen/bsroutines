classdef HeadModel < Model.Item
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
    % Date: 2016-09-18 14:23:23
    % Packaged: 2017-04-27 17:58:55
    methods
        function obj = HeadModel(id)
            obj@Model.Item(id);
            
            sf = Input.ElementItem('scale_factor',1.0,1.0 ...
                ,Input.Test(@(x) isnumscalar(x) && x > 0 ...
                ,'Scale factor must be a scalar value > 0')...
                );
            tmpl = Input.ElementItem('template_name','','Colin27' ...
                ,Input.Test(@(x) ischar(x) ...
                ,'Template prefix must be a string') ...
                );
            obj.addInput(sf,true);
            obj.addInput(tmpl,true);
            
%             obj.setDefault('scale_factor');

            obj.addOutput(Output.ElementItem('head_patch',struct));
            obj.addOutput(Output.ElementItem('brain_patch',struct));
            obj.addOutput(Output.ElementItem('brodmann',struct));
            obj.addOutput(Output.ElementItem('markers',containers.Map));
            obj.addOutput(Output.ElementItem('head_size',0));
        end
        
        function saveTemplate(obj,name)
            d = fullfile(mfilename('fullpath'),'..','..','brainprobeset','templates');
            dc = dircontent(d,'*.mat');
            if any(strcmp(dc,[name '.mat']))
                save_it = questdlg(sprintf('Overwrite "%s"?',name),'Overwrite','Yes','No','No');
            else
                save_it = 'Yes';
            end
            if strcmp(save_it,'Yes')
                brain_patch = obj.getState('brain_patch'); 
                head_patch = obj.getState('head_patch');                
                brodmann = obj.getState('brodmann'); 
                markers = obj.getState('markers');
                
                fprintf('Saving "%s"... ',name);
                    save(fullfile(d,[name '.mat']),'brain_patch','head_patch','brodmann','markers');
                fprintf('Done!\n');
            end
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            if obj.statesOkAndChanged('template_name','scale_factor')
                tmpl = obj.getState('template_name');
                d = NirsPlaner.Global().template_path;
                load(fullfile(d,[tmpl '.mat']),'head_patch');
                load(fullfile(d,[tmpl '.mat']),'brain_patch');
                load(fullfile(d,[tmpl '.mat']),'markers');
                load(fullfile(d,[tmpl '.mat']),'brodmann');
                
                f = obj.getState('scale_factor');
                head_patch = scalePatch(head_patch,f,'round_vertices',false,'reduce',[]);
                brain_patch = scalePatch(brain_patch,f,'round_vertices',false,'reduce',[]);
                [brodmann.xyz,ui] = unique(round(scalevoxels(brodmann.xyz,f)),'rows');
                brodmann.area = brodmann.area(ui);
                keys = Iter(markers.keys);
                x = scalevoxels(cell2mat(markers.values'),f);
                for k = keys
                    markers(k) = x(keys.i,:);
                end
                obj.setOutput('head_patch',head_patch);
                obj.setOutput('brain_patch',brain_patch);
                obj.setOutput('markers',markers);
                obj.setOutput('brodmann',brodmann);
                obj.setOutput('head_size',headsize(head_patch.vertices,markers));
            end
        end
    end
end