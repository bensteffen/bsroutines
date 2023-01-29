classdef ProgressStatus < hgsetget
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
    % Date: 2016-03-18 13:09:01
    % Packaged: 2017-04-27 17:58:23
    properties
        step_number;
        first_step = true;
        output_format;
        init_str;
    end
    
    properties(Access = 'private')
        progress_;
        last_output_length_;
    end
    
    methods
        function obj = ProgressStatus(step_number,output_format,init_str)
            if nargin < 1
                step_number = 0;
            end
            if nargin < 2
                output_format = '%d%%%% ';
            end
            if nargin < 3
                init_str = '';
            end
            obj.step_number = fliplr(step_number);
            obj.output_format = output_format;
            obj.progress_ = -1;
            output_str = sprintf(obj.output_format,0);
%             fprintf(output_str);
            obj.last_output_length_ = length(output_str) - 1;
            obj.init_str = [init_str repmat(' ',[1 obj.last_output_length_+ double(~isempty(init_str))])];
        end
        
        function update(obj,step_index)
            if obj.first_step
                fprintf(obj.init_str);
                obj.first_step = false;
            end
            step_index = fliplr(step_index);
            step_index = voxel2index(step_index,obj.step_number);
            curr_progress = 100*step_index/prod(obj.step_number);
            curr_progress = curr_progress - mod(curr_progress,1);
            if curr_progress > obj.progress_
                obj.progress_ = curr_progress;
                output_str = sprintf(obj.output_format,obj.progress_);
                fprintf(repmat('\b',[1 obj.last_output_length_]))
                fprintf(output_str);
                obj.last_output_length_ = length(output_str) - 1;
            end
        end
        
        function finish(obj,finish_str)
            if nargin < 2
                finish_str = '\n';
            end
            fprintf(repmat('\b',[1 obj.last_output_length_]));
            fprintf(finish_str);
        end
    end
end