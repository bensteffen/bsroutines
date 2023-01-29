classdef HdStruct < handle
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
    % Date: 2015-04-15 17:30:30
    % Packaged: 2017-04-27 17:58:03
    properties(Access = 'protected')
        name = '';
        basedir = pwd;
    end
    
    methods
        function obj = HdStruct(name,basedir)
            if nargin > 1
                obj.basedir = basedir;
            end
            obj.name = name;
        end
        
        function create(obj,data_struct)
            field_names = fieldnamesr(data_struct);
            field_names = strsplit(field_names,'.');
            for i = 1:length(field_names)
                f = field_names{i};
                val_dir = fullfile(obj.basedir,obj.name,cell2str(f(1:end-1),filesep));
                makeDir(val_dir);
                val = structvalue(data_struct,f);
                save(fullfile(val_dir,[f{end} '.mat']),'val');
            end
        end
        
        function val = load(obj,name)
            name = strsplit(name,'.');
            val_dir = fullfile(obj.basedir,obj.name,cell2str(name(1:end-1),filesep));
            val = load(fullfile(val_dir,[name{end} '.mat']));
            val = val.val;
        end
    end
end