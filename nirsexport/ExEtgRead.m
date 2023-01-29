classdef ExEtgRead < Model.ViewingItem
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
    % Date: 2016-03-22 15:51:45
    % Packaged: 2017-04-27 17:58:53
    methods
        function obj = ExEtgRead()
            obj@Model.ViewingItem('etgread');
            obj.models.add(Model.Empty('etgdir'));
            
            psinfo = Input.ElementItem('probe_info',struct,struct...
                                                   ,Input.Test(@isstruct...
                                                   ,'Table IDs must be cell string')...
                                                   );
            tbl_ids = Input.ElementItem('table_ids',{''},{''}...
                                       ,Input.Test(@iscellstr...
                                       ,'Table IDs must be cell string')...
                                       );
            tbl_id = Input.ElementItem('tbl_id','','0001'...
                                       ,Input.Test(@(x) ischar(x) && ~isempty(regexp(x,'^[0-9]*$','once'))...
                                                  ,'TBL ID must be a string containing only digits')...
                                       );
            tbl_ids.addInput(tbl_id,Input.Test(@(x,mh) any(strcmp(x,mh.getState('table_ids'))),'TBL ID not found'),obj);
            obj.addInput(psinfo);
            obj.addInput(tbl_ids);
            obj.addInput(tbl_id);

            etgprobeinfo;
            obj.setDefault('probe_info',ps);
            
            obj.addOutput(Output.ElementItem('measure',[]));
            obj.addOutput(Output.ElementItem('oxyhb',[]));
            obj.addOutput(Output.ElementItem('deoxyhb',[]));
            obj.addOutput(Output.ElementItem('mark',[]));
            obj.addOutput(Output.ElementItem('markraw',[]));
            obj.addOutput(Output.ElementItem('t',[]));
            obj.addOutput(Output.ElementItem('probe_name',''));
            obj.addOutput(Output.ElementItem('probe_number',[]));
            obj.addOutput(Output.ElementItem('chs_per_probe',[]));
        end
        
        function update(obj)
            if obj.models.entry('etgdir').stateOk('available_ids')
                obj.setInput('table_ids',obj.models.entry('etgdir').getState('available_ids'));
            else
                obj.in.entry('table_ids').setUnset();
                obj.in.entry('tbl_id').setUnset();
            end
            obj.updateOutput();
        end
    end

    methods(Access = 'protected')
        function createOutput(obj)
            if obj.models.entry('etgdir').stateOk('directory') && obj.stateOk('tbl_id')
                [psname,psn,chn] = obj.probeInfo();
                obj.setOutput('probe_name',psname);
                obj.setOutput('chs_per_probe',chn);
                obj.setOutput('probe_number',psn);
                obj.setOutput('measure',obj.readMeasure());
                hb = obj.calculateHb();
                obj.setOutput('oxyhb',hb.oxy);
                obj.setOutput('deoxyhb',hb.deoxy);
                obj.setOutput('mark',hb.mark);
                obj.setOutput('markraw',obj.readMark());
                obj.setOutput('t',(1:size(obj.getState('oxyhb'),1))');
            else
                obj.setOutput('measure',[]);
                obj.setOutput('oxyhb',[]);
                obj.setOutput('deoxyhb',[]);
                obj.setOutput('mark',[]);
                obj.setOutput('markraw',[]);
                obj.setOutput('t',[]);
            end
        end
        
        function measure = readMeasure(obj)
            tbl_dir = obj.models.entry('etgdir').getState('directory');
            entry_id = obj.getState('tbl_id');
            
            fid = fopen(fullfile(tbl_dir,[entry_id '.time']));
                nsample = length(fread(fid,inf,'char'))/16;
            fclose(fid);

            fid = fopen(fullfile(tbl_dir,[entry_id '.measure']));
                measure = fread(fid,inf,'single');
                measure = reshape(measure,[nsample length(measure)/nsample]);
            fclose(fid);
        end
        
        function hb = calculateHb(obj)
            m = obj.readMeasure();
            t = obj.readMark();

            [bl_start,bl_end] = blockstartend(t == 256);
            bl_start = [bl_start; length(t)];

            [wl1,wl2] = obj.extractWavelengths();
            wl = [wl1;wl2];
            wl = wl(:)';

            [hb.oxy,hb.deoxy,hb.mark] = deal([]);
            for b = 1:length(bl_start)-1
                curr_mblock = m(bl_start(b):bl_start(b+1)-1,:);
                baseline_sample = diff([bl_start(b) bl_end(b)]) + 1;
                [curr_oxy,curr_deoxy] = deal([]);
                for j = 1:2:size(m,2)
                    hbsignal = measure2hbsignal(curr_mblock(:,j:j+1),baseline_sample,wl([j j+1]));
                    [curr_oxy,curr_deoxy] = deal([curr_oxy hbsignal(:,1)],[curr_deoxy hbsignal(:,2)]);
                end
                [hb.oxy,hb.deoxy,hb.mark] = deal([hb.oxy; curr_oxy],[hb.deoxy; curr_deoxy],[hb.mark; t(bl_end(b)+1:bl_start(b+1)-1)]);
            end
        end
        
        function mark = readMark(obj)
            tbl_dir = obj.models.entry('etgdir').getState('directory');
            entry_id = obj.getState('tbl_id');
            
            fid = fopen(fullfile(tbl_dir,[entry_id '.mark']));
                mark = fread(fid,inf,'uint16');
            fclose(fid);
        end
        
        function [psname,pnum,probechn] = probeInfo(obj)
            ps = obj.getState('probe_info');
            pnum = obj.extractParameter('preset','type0','sProbeNumber');
            
            pnum = str2double(pnum('sProbeNumber'));
            psname = cell(1,pnum);
            probechn = zeros(1,pnum);
            for p = 1:pnum
                shape_str = sprintf('sProbeShape%d',p);
                shapeid = obj.extractParameter('preset','type0',shape_str);
                shapeid = sprintf('shape%s',shapeid(shape_str));
                psname{p} = ps.(shapeid).name;
                probechn(p) = ps.(shapeid).chnum;
            end
        end

        function [wl695,wl830] = extractWavelengths(obj)
            fc = file2cell(fullfile(obj.models.entry('etgdir').getState('directory'),[obj.getState('tbl_id') '.wave']));
            i = find(strcmp(fc(:,1),'[MAINTENANCE]'));
            fc = fc(i+1:end,:);

            wlmap = containers.Map;
            for i = 1:size(fc,1)
                opid = (fc{i,2}+1)*10 + fc{i,3}+1;
                if opid == 20
                    opid = 10;
                end
                opid = num2str(opid);
                wl = strsplit(fc{i,4},'=');
                wltag = wl{1};
                wlval = str2double(wl{2});
                wlmap(['E' opid '.' wltag]) = wlval;
            end

            [wl695,wl830] = deal([]);
            ps = obj.getState('probe_info');
            pnum = obj.extractParameter('preset','type0','sProbeNumber');
            pnum = str2double(pnum('sProbeNumber'));
            for p = 1:pnum
                shape_str = sprintf('sProbeShape%d',p);
                shapeid = obj.extractParameter('preset','type0',shape_str);
                shapeid = sprintf('shape%s',shapeid(shape_str));
                [wl695tmp,wl830tmp] = deal(zeros(1,ps.(shapeid).chnum));
                subinfo = ps.(shapeid).(sprintf('no%d',p));
                em_names = fieldnames(subinfo);
                for i = 1:length(em_names)
                    wl695tmp(subinfo.(em_names{i})) = wlmap([em_names{i} '.WAVE695']);
                    wl830tmp(subinfo.(em_names{i})) = wlmap([em_names{i} '.WAVE830']);
                end
                [wl695,wl830] = deal([wl695 wl695tmp],[wl830 wl830tmp]);
            end
        end
        
        function value = extractParameter(obj,file_ext,head_name,varargin)
            fname = fullfile(obj.models.entry('etgdir').getState('directory'),[obj.getState('tbl_id') '.' file_ext]);
            fc = linewise(fname);

            c = regexp(fc,'^\s*\[.*\]\s*$','match');
            head_lines = find(unicfun(@(x) ~isempty(x),c));
            head_names = c(head_lines);
            head_names = cellfun(@(x) x{1},head_names,'UniformOutput',false);
            head_names = cellfun(@(x) x(2:end-1),head_names,'UniformOutput',false);

            head_lines = [head_lines; length(fc)];
            head_i = find(strcmp(head_name,head_names));

            params = fc(head_lines(head_i)+1:head_lines(head_i+1)-1);

            value = extractAssignedValues(varargin,params,'=');
        end
    end
end