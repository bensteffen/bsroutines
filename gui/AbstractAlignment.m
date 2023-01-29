classdef AbstractAlignment < HandleInterface
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
    % Date: 2015-12-01 14:30:30
    % Packaged: 2017-04-27 17:58:21
    properties(SetAccess = 'protected')
        children;
        widths;
        heights;
    end
    
    methods
        function add(obj,element)
            obj.addToDo(element)
            obj.realign();
        end
        
        function remove(obj)
            obj.removeToDo(element)
            obj.realign();
        end
        
        function realign(obj,varargin)
            param_defaults.widths = [];
            param_defaults.heights = [];
            [prop_names,prop_values] = parsePropertyCell(varargin);
            assignPropertyValues(prop_names,prop_values,param_defaults);
            
            obj.setSize('widths',widths);
            obj.setSize('heights',heights);
            obj.realignToDo();
        end
    end
    
    methods(Access = 'protected')
        function setSize(obj,name,values)
            switch name
                case 'widths'
                    siz_i = 2;
                    pos_i = 3;
                case 'heights'
                    siz_i = 1;
                    pos_i = 4;
            end
            if isempty(values)
                s = size(obj.children);
                values = ones(s(siz_i),1)/s(siz_i);
            end
            
            pxi = values > 1;
            if any(pxi)
                rsize = get(findroot(obj.h),'Position');
                values(pxi) = values(pxi)/rsize(pos_i);
                values(~pxi) = values(~pxi)*(1-sum(values(pxi)));
            end
            obj.(name) = values;
        end
    end
    
    methods(Access = 'protected',Abstract = true)
        addToDo(obj);
        removeToDo(obj);
        realignToDo(obj);
    end
end