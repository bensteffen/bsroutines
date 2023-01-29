classdef EvaluationTree < IdList
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
    % Date: 2017-01-31 13:37:03
    % Packaged: 2017-04-27 17:58:02
    properties(SetAccess = 'protected')
        current_evaluation;
    end
    
    methods
        function obj = EvaluationTree(start_str)
            obj@IdList('start');
            results = IdList('result1');
            results.add(IdItem('str1',start_str));
            obj.add(results);
            obj.current_evaluation = obj;
        end
        
        function evaluate(obj,evaluation)
            r = IdIterator(obj.current_evaluation,SelectIdsCollector('^result'));
            while ~r.done()
                results_item = r.current();
                s = IdIterator(results_item,SelectIdsCollector('^str'));
                while ~s.done()
                    evaluation.evaluateString(s.current().value);
                    s.next();
                end
                r.next();
            end
            obj.current_evaluation.add(evaluation);
            obj.current_evaluation = evaluation;
        end
    end
end