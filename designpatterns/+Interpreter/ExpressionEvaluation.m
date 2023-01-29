classdef ExpressionEvaluation < IdList
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
    % Date: 2017-01-31 13:36:48
    % Packaged: 2017-04-27 17:58:02
    methods
        function obj = ExpressionEvaluation(id)
            obj@IdList(id);
        end

        function evaluateString(obj,str)
            results = IdList(sprintf('result%d',obj.length+1));
            str_it = Iter(obj.specificEvaluation(str));
            for s = str_it
                results.add(IdItem(sprintf('str%d',str_it.i),s));
            end
            obj.add(results)
        end
    end
    
    methods(Abstract = true)
        results_cell = specificEvaluation(obj,str);
    end
end