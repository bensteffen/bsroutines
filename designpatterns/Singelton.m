classdef Singelton < handle
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
    % Date: 2017-04-11 15:18:22
    % Packaged: 2017-04-27 17:57:59
    properties(SetAccess = 'protected')
        first_instance;
    end
    
    methods(Access = 'protected')
        function obj = Singelton
            obj = Singelton.getInstance(obj);
        end
    end
    
    methods(Static = true,Access = 'protected')
        function h = getInstance(obj)
            persistent unique_instance;
            if isempty(unique_instance)
                unique_instance = obj;
                obj.first_instance = true;
            else
                obj = unique_instance;
                obj.first_instance = false;
            end
            h = unique_instance;
        end
    end
end