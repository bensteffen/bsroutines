classdef KeyList < List
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
    % Date: 2016-01-26 11:13:16
    % Packaged: 2017-04-27 17:57:58
    methods
        function obj = KeyList(varargin)
            obj.addKeys(varargin{:});
        end
        
        function addKeys(obj,varargin)
            for k = Iter(varargin)
                if ~isa(k,'Key') 
                    k = Key(k);
                end
                obj.append(k);
            end
        end
        
        function l = selectValid(obj)
            l = KeyList();
            for k = Iter(obj)
                if k.isvalid
                    l.append(k);
                end
            end
        end
        
        function l = selectExisting(obj,data_base)
            v = obj.selectValid();
            l = KeyList();
            for k = Iter(v)
                if data_base.hasData(k)
                    l.append(k);
                end
            end
        end
    end
end