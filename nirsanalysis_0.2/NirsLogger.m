%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 31-Jan-2012 18:46:10


classdef NirsLogger < PropertyObject
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
    % Date: 2017-04-11 16:10:34
    % Packaged: 2017-04-27 17:58:44
    methods
        function obj = NirsLogger()
            [obj.log_entries,obj.new_entries] = deal(List(),List());
            obj.has_new_entries = false;
            
            obj.addProperty(Input.ElementItem('subject',[],[],Input.Test(@(x) isempty(x) || (isnumscalar(x) && x > 0),'Subject ID must be [] or a scalar > 0')))
            obj.addProperty(Input.String('input_names',''));
            obj.addProperty(Input.String('output_names',''));
            obj.addProperty(Input.String('logfile_name','nirslog.txt'));
        end
        
        function log(obj,str,varargin)
            str = sprintf(str,varargin{:});
            str = regexprep(str,'\$s',stringify(obj.getProperty('subject')));
            str = regexprep(str,'\$i',obj.getProperty('input_names'));
            str = regexprep(str,'\$o',obj.getProperty('output_names'));
            obj.log_entries.append(str);
            obj.new_entries.append(str);
            obj.has_new_entries = true;
        end
        
        function reset(obj)
            obj.new_entries = List();
            obj.has_new_entries = false;
        end
        
        function print(obj,type,target,prefix)
            if nargin < 4
                prefix = '';
            end
            switch type
                case 'current'
                    c = obj.new_entries.toCell();
                case 'all'
                    c = obj.log_entries.toCell();
                otherwise
                    error('NirsLogger.print(type,target): type must be "current" or all');
            end
            if ~isempty(c)
                c = nonunicfun(@(x) [prefix x],c);
                s = cell2str(c,sprintf('\n'));
                switch target
                    case 'console'
                        fprintf('%s\n',s);
                    case 'file'
                        fid = fopen(obj.getProperty('logfile_name'),'a');
                            fprintf(fid,'%s\n',s);
                        fclose(fid);
                    otherwise
                        error('NirsLogger.print(type,target): type must be "console" or file');
                end
            end
        end
    end
    
    properties(SetAccess = 'protected')
        log_entries;
        new_entries;
        has_new_entries;
    end
end