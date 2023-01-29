classdef ProbeWriter < Model.Item
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
    % Date: 2017-04-27 15:07:14
    % Packaged: 2017-04-27 17:58:55
    properties(SetAccess = 'protected')
        probe_list;
        display_handle;
    end
    
    methods
        function obj = ProbeWriter(id,probe_list,display_handle)
            obj@Model.Item(id);
            obj.probe_list = probe_list;
            obj.display_handle = display_handle;
            
            obj.addSignal(StateSignal('start_writing'));
            obj.addSignal(StateSignal('export_display'));
            obj.addInput(Input.File('write_path',fullfile(NirsPlaner.Global().planer_path,'xyz'),'dir'));
            obj.addInput(Input.ElementItem('file_name_template','','NIRS-probesetXYZ_$n_$t',Input.Test(@ischar,'File name template must be a string')));
            
            obj.setDefault('write_path');
            obj.setDefault('file_name_template');
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            if obj.isActive('start_writing')
                for p = Iter(obj.probe_list)
                    fnameabr = containers.Map();
                    fnameabr('n') = p.id;
%                     fnameabr('r') = sprintf('%son%s',p.getState('reference_probe_point'),p.getState('reference_head_point'));
                    fnameabr('t') = p.getState('template_name');
                    
                    n = [sprintTemplate(obj.getState('file_name_template'),fnameabr) '.txt'];
                    fname = fullfile(obj.getState('write_path'),n);
                    obj.writeProbeFile(p,fname);
                end
            end
            if obj.isActive('export_display')
                fname = uiputfile('probe_arrangment.png','Picture file name');
                if fname ~= 0
                    export_fig(obj.display_handle,fname,'-r300');
                end
            end
        end
    end
    
    methods(Access = 'protected',Static = true)
        function writeProbeFile(p,fname)
            n = regexpfind(fieldnames(p.getState('probe_data')),'^CH','list');
            fcontent = [n num2cell(p.getState('channel_xyz'))];
            cell2file(fname,fcontent,{'%s','%.2f','%.2f','%.2f'});
            fid = fopen(fname,'a'); 
                fprintf(fid,'\n\nTEMPLATE %s\n',p.getState('template_name')); 
            fclose(fid);
        end
    end
end