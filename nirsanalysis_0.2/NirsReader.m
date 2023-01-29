%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 31-Jan-2012 18:30:58


classdef NirsReader < NirsObject
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
    % Date: 2016-05-10 16:36:17
    % Packaged: 2017-04-27 17:58:44
    properties
        read_types_ = {'etg4000','etg4000_trigger','xls','mat','txt','binary'};
    end    
    
    methods
        function obj = NirsReader()
        end
        
        function data = read(obj)
            read_type = strsplit(obj.getProperty('read_type'),'.');
            if length(read_type) > 1
                read_specifier = read_type{2};
            else
                read_specifier = '';
            end
            read_type = read_type{1};
            fname = obj.getProperty('file_name');
            switch read_type
                case 'etg4000'
                    data = NAio.readNirsData(fname);
                case 'nirx'
                    data = NAio.nirx.readNirxData(fname);
                case 'etg4000_trigger'
                    [~, data] = NAio.readNirsData(fname);
                case 'xls'
                    data = xlsread(fname);
                case 'mat'
                    if ~isempty(read_specifier)
                        file_info = whos('-file',fname);
                        for i = 1:length(file_info)
                            if strcmp(file_info(i).name,read_specifier)
                                data = load(fname,read_specifier);
                                data = getfield(data,read_specifier);
                                return;
                            end
                        end
                        error(['NirsReader.read(mat): Could not find variable "' read_specifier '" in mat-file "' fname '"']);                        
                    else
                        data = load(fname);
                        fields = fieldnames(data);
                        data = getfield(data,fields{1});
                    end
                case 'txt'
                    data = textread(fname);
                case 'binary'
                    fid = fopen(fname);
                        data = fread(fid,Inf,read_specifier);
                    fclose(fid);
                otherwise
                    error(['NirsReader.read: Unknown read type "' read_type '". Must be one of these: "' cell2str(obj.read_types_,'", "') '"']);
            end            
        end
        
        function read_type_list = getReadTypeList(obj)
            read_type_list = obj.read_types_;
        end
    end
    
    methods(Access = 'protected')
        function obj = update(obj,prop_name,prop_value)
        end
    end
    
    methods(Static = true)
        function prop_info = getPropertyInfos()
            prop_info.file_name.test_fcn_handle = @(x) ischar(x);
            prop_info.file_name.error_str = 'File name must be a string.';
            
            prop_info.variable_name.test_fcn_handle = @(x) ischar(x);
            prop_info.variable_name.error_str = 'Variable name must be a string.';
            
            prop_info.read_type.test_fcn_handle = @(x) ischar(x);
            prop_info.read_type.error_str = 'Read type name must be a string.';
        end
    end
    
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'reader';
        end
    end    
end