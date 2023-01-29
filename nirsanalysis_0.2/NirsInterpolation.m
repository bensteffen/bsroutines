classdef NirsInterpolation < NirsObject & TagMatrix
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
    % Date: 2016-10-31 15:43:23
    % Packaged: 2017-04-27 17:58:44
    properties
        interp_data_;
        subjn_;
    end
    
    methods
        function obj = NirsInterpolation(varargin)
            obj = obj@NirsObject(varargin);
            obj.interp_data_ = cell(0,4);
            obj.subjn_ = 0;
        end
        
        function obj = addChannelsToInterpolate(obj,ch2i_cell)
            if iscell(ch2i_cell) && size(ch2i_cell,2) == 4
                ch2i_cell(:,4) = cellfun(@num2str,ch2i_cell(:,4),'UniformOutput',false);
                obj.interp_data_ = [obj.interp_data_; ch2i_cell];
            else
                error('NirsInterpolation.findChannelsToInterpolate: Input must be a cell array with 4 columns.');
            end
            obj.showChannelsToInterpolate();
        end
        
        function obj = findChannelsToInterpolate(obj,subject_data)
            dnames = obj.getProperty('data2interp');
            pnames = obj.getProperty('probesets2interp');
            thresh = obj.getProperty('variance_threshold');
            subjects = exclude(subject_data.subjects(),obj.getProperty('experiment').getProperty('subjects2skip'));
            obj.subjn_ = length(subjects);
            
            obj.interp_data_ = [];
            switch obj.getProperty('detection_method')
                case 'within_subject_variance'
                    for s = subjects
                        for d = 1:length(dnames)
                            s2 = var(subject_data.getSubjectData(s,dnames{d}));
                            s2n = s2/std(s2);
                            ch2i = find(s2n >= thresh);
                            if ~isempty(ch2i)
                                obj.interp_data_ = [obj.interp_data_; {s,dnames{d},pnames{d},num2str(ch2i)}];
                            end
                        end
                    end
                case 'overall_std_spikes'
                    for d = 1:length(dnames)
                        sd = [];
                        for s = subjects
                        	sd = [sd; std(subject_data.getSubjectData(s,dnames{d}))];
                        end
                        dim = size(sd);
                        spks = findspikes(sd(:),thresh);
                        spks = index2voxel(spks(:,1),dim);
                        spks_subjects = subjects(unique(spks(:,1)));
                        for s = spks_subjects
                            obj.interp_data_ = [obj.interp_data_; {s,dnames{d},pnames{d},num2str(spks(spks(:,1) == s,2)')}];
                        end
                    end
            end
            obj.interp_data_ = sortrows(obj.interp_data_,1);
            
            if onoff2flag(obj.getProperty('gui'))
                obj = obj.launchGui(subject_data);
            else
                obj.showChannelsToInterpolate();
            end
        end
        
        function obj = launchGui(obj,subject_data)
                ig = InterpolGui();
                set(ig,'subject_data',subject_data);
                set(ig,'subjects',exclude(subject_data.subjects(),obj.getProperty('experiment').getProperty('subjects2skip')));
                set(ig,'probesets',obj.getProperty('probesets'));
                set(ig,'variance_thresh',obj.getProperty('variance_threshold'));
                set(ig,'data_names',obj.getProperty('data2interp'));
                set(ig,'probe_names',obj.getProperty('probesets2interp'));
                set(ig,'interp_data',obj.interp_data_);
                ig.show();
                obj.interp_data_ = get(ig,'interp_data');
                obj.showChannelsToInterpolate();
        end

        function subject_data = interpolate(obj,subject_data)
            fprintf('Interpolating...\n')
            obj = obj.setDimension({'sid','data_name','interp_data'});
            for c = 1:size(obj.interp_data_,1)
                s = obj.interp_data_{c,1};
                dname = obj.interp_data_{c,2};
                ch2i = obj.interp_data_{c,4};
                if ~isempty(ch2i)
                    pname = obj.interp_data_{c,3};
                    obj = obj.add({s,dname,'chs2interp'},str2num(ch2i));
                    obj = obj.add({s,dname,'probeset_name'},pname);
                end
            end
            
            for s = cell2mat(obj.tags(1)')
                fprintf('\tsubject %d\n',s)
                dnames = obj.extract({s,':','chs2interp'}).tags(1);
                for d = 1:length(dnames)
                    D = subject_data.getSubjectData(s,dnames{d});
                    pname = obj.get({s,dnames{d},'probeset_name'});
                    chmx = obj.getProperty('probesets').get({pname,'probeset'}).channelMatrix();
                    opd = obj.getProperty('probesets').get({pname,'probeset'}).getProperty('optode_distance');
                    ch2i = obj.get({s,dnames{d},'chs2interp'});
                    if ~isempty(ch2i)
                        fprintf('\t\t%s: %s\n',dnames{d},cell2str(cellfun(@num2str,num2cell(ch2i),'UniformOutput',false),', '));
                        subject_data = subject_data.add({s,dnames{d}},NAfilt.gaussianNirsInterp(D,chmx,ch2i,opd));
                    end
                end
            end
            fprintf('... Done!\n');
        end
        
        function showChannelsToInterpolate(obj)
            if size(obj.interp_data_,1) == 0
                fprintf('No Channels to interpolate.\n');
            else
%                 t = PrintTable;
%                 t.HasHeader = true;
%                 t.addRow('','Subject ID','Data name','Probeset','Channels')
%                 for c = 1:size(obj.interp_data_,1)
%                     s = obj.interp_data_{c,1};
%                     dname = obj.interp_data_{c,2};
%                     pname = obj.interp_data_{c,3};
%                     ch2i = obj.interp_data_{c,4};
%                     if ~isempty(ch2i)
%                         t.addRow('',s,dname,pname,ch2i);
%                     end
%                 end
%                 fprintf('Channels to interpolate:\n');
%                 t.display();
                pnames = unique(obj.interp_data_(:,3));
                totaln.chs2i = 0;
                totaln.chs = 0;
                pt = NirsPlotTool();
                for p = 1:length(pnames)
                    ps = obj.getProperty('probesets').get({pnames{p},'probeset'});
                    chn = length(ps.channels());
                    totaln.chs = totaln.chs + chn;
                    pt = pt.setProperty('probesets',{'name',pnames{p},'probeset',ps});
                    rows = strcmp(obj.interp_data_(:,3),pnames{p});
                    pschs2i = str2num(cell2str(obj.interp_data_(rows,4),' '));
                    n = length(pschs2i);
                    totaln.chs2i = totaln.chs2i + n;
                    vals = 100*histc(pschs2i,1:chn)/n;
                    pt = pt.setProperty('values2map',{vals},'probesets2map',{pnames{p}},'color_map','gap','color_limit',[0 round(max(vals))]);
%                     pt.map('values');
                end
                totaln.chs = totaln.chs*obj.subjn_;
                fprintf('%.0f %% of the channels (%d of %d) will be interpolated.\n',round(100*totaln.chs2i)/totaln.chs,totaln.chs2i,totaln.chs);
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = update(obj,prop_name,prop_value)
        end
    end
    
    methods(Static = true)
        function prop_info = getPropertyInfos()
            prop_info.probesets.sub_names = {'name','probeset'};
            prop_info.probesets.test_fcn_handle = {@(x) ischar(x),@(x) isa(x,'NirsProbeset')};
            prop_info.probesets.error_str = {'Probeset name must be a string.','Probeset must be a NirsProbeset'};
            
            prop_info.gui.test_fcn_handle = @(x) any(strcmpi(x,{'on','off'}));
            prop_info.gui.error_str = 'Gui flag must be ''on'' or ''off''';
            
            prop_info.variance_threshold.test_fcn_handle = @(x) isnumeric(x) && isscalar(x);
            prop_info.variance_threshold.error_str = 'Variance threshold must be a numeric scalar.';
            
            prop_info.detection_method.test_fcn_handle = @(x) any(strcmpi(x,{'within_subject_variance','overall_std_spikes'}));
            prop_info.detection_method.error_str = 'Variance threshold must be ''within_subject_variance'' or ''overall_std_spikes''.';
            
            prop_info.data2interp.test_fcn_handle = @(x) iscellstr(x);
            prop_info.data2interp.error_str = 'Data names must be string cell.';
            
            prop_info.probesets2interp.test_fcn_handle = @(x) iscellstr(x);
            prop_info.probesets2interp.error_str = 'Probeset names must be string cell.';
        end
    end
    
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'interpolation';
        end
        
    end  
end