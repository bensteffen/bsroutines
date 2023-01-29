classdef SplitArguments < Interpreter.ExpressionEvaluation
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
    % Date: 2017-02-01 15:22:03
    % Packaged: 2017-04-27 17:58:01
    methods
        function obj = SplitArguments()
            obj@Interpreter.ExpressionEvaluation('split_arguments')
        end
        
        function c = specificEvaluation(obj,str)
            c = strsplit(str,',');
        end
        
        function names = inputNames(obj)
            names = obj.entry('result1').toCell('values');
        end
        
        function names = outputNames(obj)
            if obj.hasEntry('result2')
                names = obj.entry('result2').toCell('values');
            else
%                 names = obj.inputNames();
                names = {''};
            end
        end
    end
end