classdef TestModel < Model & PropertyListObject    
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
    % Date: 2014-09-26 17:55:20
    % Packaged: 2017-04-27 17:58:25
    methods
        function obj = TestModel(a,b)
            obj.props.add(Property('yfactor',1,@isscalar));
            obj.state.a = a;
            obj.state.b = b;
            obj.state.b0 = b;
        end
    end

    methods(Access = 'protected')
        function propertyUpdate(obj,name)
            switch name
                case 'yfactor'
                    obj.state.b = obj.getProperty('yfactor')*obj.state.b0;
            end
        end
    end
end