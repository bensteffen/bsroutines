%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 20-Jan-2012 19:40:16


classdef NirsDataFunctor < NirsObject
    
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
    % Date: 2014-06-27 15:49:56
    % Packaged: 2017-04-27 17:58:43
    methods 
        function obj = NirsDataFunctor(varargin)
            obj = obj@NirsObject(varargin);
        end
        
        function name = getFunctionName(obj)
            name = func2str(obj.getProperty('function_handle'));
        end
        
        function [names data_number argument_number] = getInputInfo(obj)
            names = obj.getProperty('input_names');
            data_number = size(names,2);
            argument_number = size(names,1);              
        end
        
        
        function [names data_number argument_number] = getOutputInfo(obj)
            output_names = obj.getProperty('output_names');
            if isempty(output_names)
                input_names = obj.getProperty('input_names');
                names = input_names(1,:);
                data_number = size(input_names,2);
                argument_number = 1;            
            else
                names = output_names;
                data_number = size(names,2);
                argument_number = size(names,1);                   
            end
        end
        
        function out_data = start(obj, in_data)
            input_names = obj.getProperty('input_names');
            output_names = obj.getProperty('output_names');
            parameter = obj.getProperty('parameters');
            fhandle = obj.getProperty('function_handle');
            
            input_eval_str = obj.getEvalString('in_data',size(input_names,1));
            
            
            
            if isempty(output_names)
                output_eval_str = obj.getEvalString('out_data',1);
                output_names = input_names;
            else
                output_eval_str = obj.getEvalString('out_data',size(output_names,1));
            end
            
            if isempty(parameter)
                parameter_eval_str = '';
            else
                parameter_eval_str = [',' obj.getEvalString('parameter',length(obj.getProperty('parameters')))];
            end
            
            if size(output_names,2) == size(input_names,2)
                eval(['[' output_eval_str '] = fhandle(' input_eval_str parameter_eval_str ');']);
            else
                error('NirsDataFunctor.start: input and output name lists must have the number of columns');
            end
        end
    end
    
    methods(Access = 'protected')
        function [eval_str] = getEvalString(obj,prefix,number)
            eval_str = cell(1,number);
            for i = 1:number
                eval_str{i} = [prefix '{' num2str(i) '}'];
            end
            eval_str = cell2str(eval_str,',');
        end
        
        function obj = update(obj,prop_name,prop_value)
        end
    end
    
    methods(Static = true)
        function prop_info = getPropertyInfos()
            prop_info.function_handle.test_fcn_handle = @(x) true;
            prop_info.function_handle.error_str = 'Function not found.';
            
            prop_info.parameters.test_fcn_handle = @(x) iscell(x) && (isempty(x) || isvector(x));
            prop_info.parameters.error_str = 'Parameter list must be a cell vector.';
            
            prop_info.input_names.test_fcn_handle = @(x) iscellstr(x);
            prop_info.input_names.error_str = 'Input names must be a cell string.';
            
            prop_info.output_names.test_fcn_handle = @(x) iscellstr(x);
            prop_info.output_names.error_str = 'Output names must be a cell string.';
        end
    end
    
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'functor';
        end        
    end
end