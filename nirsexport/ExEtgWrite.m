classdef ExEtgWrite < Model.ViewingItem
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
    % Date: 2017-04-06 18:14:04
    % Packaged: 2017-04-27 17:58:53
    properties(Access = 'protected')
        fnameabr = containers.Map;
        last_tbldir = '';
    end
    
    methods
        function obj = ExEtgWrite()
            obj@Model.ViewingItem('etgwrite');
            
            obj.models.add(Model.Empty('etgdir'));
            obj.models.add(Model.Empty('etgread'));
            obj.models.add(Model.Empty('etgtable'));
            
            ids2write = Input.ElementItem('ids2write',{''},{''}...
                                          ,Input.Test(@iscellstr...
                                          ,'Table IDs must be cell string')...
                                          );
                                      
            export_dir = Input.ElementItem('export_directory','',''...
                                        ,Input.Test(@ischar...
                                        ,'Export directory does not exist.')...
                                        );
            split_ps = Input.ElementItem('split_probes',[],false...
                                                    ,Input.Test(@islogical ...
                                                    ,'Split probe set flag must be logical')...
                                                    );
            fnt = Input.ElementItem('fname_template','','$i_$p_$h' ...
                                                    ,Input.Test(@ischar ...
                                                    ,'Split probe set flag must be logical')...
                                                    );
            export_type = Input.Options('export_type',{'Hb','Raw'});
            obj.addInput(ids2write);
            obj.addInput(export_dir);
            obj.addInput(split_ps);
            obj.addInput(fnt);
            obj.addInput(export_type);
            obj.setDefault('split_probes',false);
            obj.setDefault('fname_template');
            obj.setDefault('export_type');
        end
        
        function update(obj)
            if obj.models.entry('etgdir').stateOk('directory')
                if obj.models.entry('etgdir').stateChanged('directory')
                    obj.setDefault('export_directory',fullfile(obj.models.entry('etgdir').getState('directory'),'hb'));
                end
                if ~obj.stateOk('export_directory')
                    obj.setDefault('export_directory');
                end
                obj.updateOutput();
            else
                obj.setUnset('export_directory');
                obj.updateOutput();
            end
            if obj.stateChanged('export_directory')
                makeDir(obj.getState('export_directory'));
            end
            
            if obj.models.entry('etgtable').stateOk('row_selection')
                row_selection = obj.models.entry('etgtable').getState('row_selection');
                row_selection = cell2mat(row_selection(:,1));
                tab = obj.models.entry('etgtable').getState('table_data');
                obj.setInput('ids2write',tab(row_selection,1:5));
            end
            if obj.models.entry('etgtable').isActive('start_export')
                obj.updateOutput();
            end
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            if obj.stateOk('ids2write') && obj.models.entry('etgtable').isActive('start_export')
                obj.models.entry('etgtable').deactivateSignals();
                if ~obj.stateOk('export_directory')
                    obj.setDefault('export_directory');
                end
                makeDir(obj.getState('export_directory'));
                fnametpl = obj.getState('fname_template');
                exdir = obj.getState('export_directory');
                ids = obj.getState('ids2write');
                reader = obj.models.entry('etgread');
                
                
                obj.status.setInput('progress_name','Writing CSV-files... '); obj.status.updateOutput();
                obj.status.setInput('progress_length',size(ids,1));
                for i = 1:size(ids,1)
                    id = ids(i,:);
                    reader.setInput('tbl_id',id{1});
                    reader.updateOutput();
                    obj.fnameabr('i') = id{2};
                    obj.fnameabr('c') = id{3};
                    obj.fnameabr('d') = id{4};
                    obj.fnameabr('e') = id{5};
                    if obj.stateOk('export_type')
                        switch obj.getState('export_type')
                            case 'Hb'
                                mark = reader.getState('mark');
                                oxy = reader.getState('oxyhb');
                                deoxy = reader.getState('deoxyhb');
                                
                                if ~obj.stateOk('split_probes') || ~obj.getState('split_probes')
                                    pnum = 1;
                                    chcols = [0 size(oxy,2)];
                                    psname = 'Probe';
                                else
                                    pnum = reader.getState('probe_number');
                                    chcols = [0 cumsum(reader.getState('chs_per_probe'))];
                                    psname = 'Probe%d';
                                end

                                for p = 1:pnum
                                    obj.fnameabr('p') = sprintf(psname,p);
                                    cols = chcols(p)+1:chcols(p+1);

                                    obj.fnameabr('h') = 'Oxy';
                                    obj.writeCsv(exdir...
                                                ,sprintTemplate(fnametpl,obj.fnameabr)...
                                                ,'Oxy'...
                                                ,oxy(:,cols)...
                                                ,mark);

                                    obj.fnameabr('h') = 'Deoxy';
                                    obj.writeCsv(exdir...
                                                ,sprintTemplate(fnametpl,obj.fnameabr)...
                                                ,'Deoxy'...
                                                ,deoxy(:,cols)...
                                                ,mark);
                                end
                            case 'Raw'
                                raw = reader.getState('measure');
                                mark = reader.getState('markraw');
                                obj.fnameabr('p') = 'Probe';
                                
                                obj.fnameabr('h') = 'WLshort';
                                obj.writeCsv(exdir...
                                            ,sprintTemplate(fnametpl,obj.fnameabr)...
                                            ,'Raw'...
                                            ,raw(:,1:2:end)...
                                            ,mark);
                                        
                                obj.fnameabr('h') = 'WLlong';
                                obj.writeCsv(exdir...
                                            ,sprintTemplate(fnametpl,obj.fnameabr)...
                                            ,'Raw'...
                                            ,raw(:,2:2:end)...
                                            ,mark);
                        end
                        obj.status.updateOutput();
                    end
                end
                obj.status.updateOutput();
            end
        end
    end
    
    methods(Access = 'protected',Static = true)
        function writeCsv(exdir,fname_base,hbname,hb,tr)
            [nsample,chn] = size(hb);

            tr = tr(end-nsample+1:end)/17;
            hb   = [(1:nsample)' hb tr];

            header = sprintf(['Probe1(%s)\t' repmat('CH%d\t',[1 chn]) 'Mark\n'],hbname,1:chn);
            format = ['%d\t' repmat('%.4f\t',[1 chn]) '%d\n'];
            fname = fullfile(exdir,sprintf('%s.csv',fname_base));
            fid = fopen(fname,'w');
                fprintf(fid,'%s',header);
                fprintf(fid,format,hb');
            fclose(fid);
        end
    end
end