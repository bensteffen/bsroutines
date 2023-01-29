classdef PropertyListObject < handle
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
    % Date: 2014-09-26 20:26:40
    % Packaged: 2017-04-27 17:57:59
    properties(Access = 'protected')
        props;
    end

    methods
        function setProperty(obj,name,val)
            obj.props.entry(name).setValue(val);
            obj.propertyUpdate(name);
        end
        
        function resetProperty(obj,name)
            obj.props.entry(name).reset();
            obj.propertyUpdate(name);
        end
        
        function val = getProperty(obj,name)
            val = obj.props.entry(name).getValue();
        end
        
        function has_flag = hasProperty(obj,name)
            has_flag = obj.props.hasEntry(name);
        end
        
        function setDefault(obj,name,val)
            obj.props.entry(name).reset(val);
            obj.propertyUpdate(name);
        end
    end

    methods(Access = 'protected')
        function obj = PropertyListObject()
            obj.props = IdList();
        end
    end
    
    methods(Access = 'protected',Abstract = true)
        propertyUpdate(obj,name);
    end
end