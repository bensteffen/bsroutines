classdef DependentInput < IdList
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
    % Date: 2014-09-29 15:56:14
    % Packaged: 2017-04-27 17:57:57
    properties
        value_test_handle;
    end
    
    methods
        function obj = DependentInput(name)
            obj@IdList(name);
        end
        
        function flag = dependentTest(obj)
            all_set = true;
            i = IdIterator(obj);
            while ~i.done()
                all_set = all_set & i.current().was_set;
                i.next();
            end
            if all_set
                flag = obj.value_test_handle(obj);
            else
                flag = true;
            end
        end
    end
end