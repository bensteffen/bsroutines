classdef TimeSeries < Data.Processor
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
    % Date: 2017-04-19 11:39:50
    % Packaged: 2017-04-27 17:58:01
    methods
        function obj = TimeSeries(id,varargin)
            obj@Data.Processor(id,varargin{:});
        end
    end
    
    methods(Access = 'protected')
        function out = process(obj,function_handle,in,out)
            is_ts = cellfun(@(ts) isa(ts,'TimeSeries'),in);
            ts1 = in{is_ts(1)};
            in(is_ts) = nonunicfun(@(ts) ts.x,in(is_ts));
            
            [out{:}] = function_handle(in{:});
            out = nonunicfun(@(x) TimeSeries(x,ts1.fs,ts1.offset),out);
        end
    end
end