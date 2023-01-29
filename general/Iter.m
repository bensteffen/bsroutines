classdef Iter < handle
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
    % Date: 2016-06-02 10:55:19
    % Packaged: 2017-04-27 17:58:03
    properties(Access = 'protected')
        c = {};
        progress_status;
    end
    
    properties(SetAccess = 'protected')
        i = 0;
        n = 0;
        collection;
    end
    
    methods
        function obj = Iter(c,status_str)
            if ismethod(c,'iter')
                obj.c = c.iter();
            else
                obj.c = c(:)';
            end
            obj.n = numel(obj.c);
            if nargin > 1
                obj.progress_status = ProgressStatus(obj.n,'%d%%%% ',status_str);
            end
        end
        
        function v = subsref(obj,s)
            switch s.type
                case '.'
                    v = builtin('subsref',obj,s);
                otherwise
                    if iscell(obj.c)
                        v = obj.c{s.subs{2}};
                    else
                        v = builtin('subsref',obj.c,s);
                    end
                    obj.i = obj.i + 1;
                    if obj.i == obj.n + 1
                        obj.i = 1; 
                    end
                    if ~isempty(obj.progress_status)
                        obj.updateStatus();
                    end
            end
        end
        
        function [nrows,ncols] = size(obj,dim)
            nrows = 1;
            ncols = numel(obj.c);
        end
        
        function collect(obj,data)
            obj.collection = [obj.collection;data];
        end
    end
    
    methods(Access = 'protected')
        function updateStatus(obj)
            obj.progress_status.update(obj.i);
            if obj.i == obj.n
                obj.progress_status.finish('Done!\n');
            end
        end
    end
end