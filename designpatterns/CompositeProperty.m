classdef CompositeProperty < DataBase & Subject
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
    % Date: 2014-12-05 14:20:37
    % Packaged: 2017-04-27 17:57:56
    methods
        function obj = CompositeProperty(id,varargin)
            obj@DataBase(id);
            for i = 1:length(varargin)
                obj.add(varargin{i});
            end
        end
        
        function value = getProperty(obj,varargin)
            value = obj.getData(varargin);
        end
        
        function setProperty(obj,varargin)
            obj.last_property = varargin(1:end-1);
            p = obj.getItem(obj.last_property);
            p.setValue(varargin{end});
%             obj.notifyObservers();
        end

        function reset(obj)
            i = IdIterator(obj,AllTreeIdsCollector());
            while ~i.done()
                i.current().reset();
                i.next();
            end
        end
    end
    
    properties(SetAccess = 'protected')
        last_property;
    end
end