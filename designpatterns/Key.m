classdef Key
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
    % Date: 2016-01-26 10:29:57
    % Packaged: 2017-04-27 17:57:58
    properties(SetAccess = 'protected')
        value = '';
        isvalid = false;
    end
    
    methods
        function obj = Key(varargin)
            obj = obj.setKey(varargin{:});
        end
        
        function obj = setKey(obj,varargin)
            k = Key.asCell(varargin{:});
            obj.value = k;
            obj.isvalid = false;
            if Key.valid(k)
                obj.isvalid = true;
            end
        end
    end
    
    methods(Static = true)
        function key = asCell(varargin)
            key = {};
            for k = Iter(varargin)
                if ischar(k)
                    k = strsplit(k,'.');
                end
                key = [key k];
            end
        end
        
        function key = asString(varargin)
            key = strjoin(Key.asCell(varargin{:}),'.');
        end
        
        function flag = valid(varargin)
            flag = all(cellfun(@isvarname,Key.asCell(varargin{:})));
        end
    end
end