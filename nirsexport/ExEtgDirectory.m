classdef ExEtgDirectory < Model.Item
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
    % Date: 2016-11-24 13:33:45
    % Packaged: 2017-04-27 17:58:53
    methods
        function obj = ExEtgDirectory()
            obj@Model.Item('etgdir');
            tbl_dir = Input.ElementItem('directory','','' ...
                                         ,Input.Test(@(x) (exist(x,'dir') && exist(fullfile(x,'ETG4000Export.TBL'),'file')) ...
                                                       || (exist(x,'file') && strend(x,[filesep 'ETG4000Export.TBL'])) ...
                                         ,'ETG4000Export.TBL not found')...
                                         );
            obj.addInput(tbl_dir);
            
            obj.addOutput(Output.ElementItem('table',{'','','',''}));
            obj.addOutput(Output.ElementItem('available_ids',{''}));
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            if obj.stateOk('directory')
                path = obj.getState('directory');
                if strend(path,[filesep 'ETG4000Export.TBL'])
                    path = fileparts(path);
                end
                obj.setInput('directory',path);
                fc = linewise(fullfile(path,'ETG4000Export.TBL'));

                c = regexp(fc,'^\s*\[EXPORT\d*\]\s*$','match');
                id_lines = find(cellfun(@(x) ~isempty(x),c));
                id_lines = [id_lines; length(fc)];

                table = {};
                obj.status.setInput('progress_name','Creating table... ');
                obj.status.setInput('progress_length',length(id_lines));
                for i = 1:length(id_lines)-1
                    value_list = fc(id_lines(i)+1:id_lines(i+1)-1);
                    vals = extractAssignedValues({'FileNo','ID','Name','Date','Comment','Comment1','Comment2'},value_list,'=');
                    id = int2digitstr(str2num(vals('FileNo')),4);
                    
                    fname = fullfile(path,[id '.time']);
                    fid = fopen(fname);
                    if fid > 0
                        t0 = datevec(char(fread(fid,11,'char')'));
                        fseek(fid,-16,1);
                        t1 = datevec(char(fread(fid,11,'char')'));
                        fseek(fid,0,-1);
                    fclose(fid);
                    dt = etime(t1,t0);
                    dtstr = sprintf('%d:%s',floor(dt/60),int2digitstr(round(mod(dt,60)),2));
                    
                    table = [table; {id vals('Name') vals('Comment') vals('Comment1') vals('Comment2') vals('Date') dtstr}];
                    
                    obj.status.updateOutput();
                    end
                end
                obj.status.updateOutput();
                obj.setOutput('table',table);
                obj.setOutput('available_ids',table(:,1));
            end
        end
    end
end