classdef IterCell
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
    % Date: 2015-04-17 14:39:09
    % Packaged: 2017-04-27 17:58:03
    properties(Access = 'protected')
        c = {};
        i = 0;
    end
    
    methods
        function obj = IterCell(c)
            if iscell(c)
                obj.c = c(:)';
            else
                error('IterCell: Needs cell input.');
            end
        end
        
        function v = subsref(obj,s)
            v = obj.c{s.subs{2}};
        end
        
        function [nrows,ncols] = size(obj,dim)
            nrows = 1;
            ncols = numel(obj.c);
        end
    end
end