classdef SizeChangeAlignment < HandleInterface
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
    % Date: 2017-03-21 19:01:47
    % Packaged: 2017-04-27 17:58:25
    properties(SetAccess = 'protected')
        alg;
        start_size;
        type;
    end
    
    methods 
        function obj = SizeChangeAlignment(type,guifig,start_size)
            if nargin < 3
                start_size = [0.5 0.5];
            end
            obj.alg = MatrixAlignment(guifig.figh);
            obj.h = obj.alg.h;
            switch lower(type)
                case 'h'
                    dim_name = 'widths';
                case 'v'
                    dim_name = 'heights';
                otherwise
                    error('SizeChangeBar(): Type must be "h" or "v"');
            end
            obj.type = type;
            scb = SizeChangeBar(type,guifig,obj.alg); scb.show();
            i = obj.elementi2algi(2);
            obj.alg.addElement(i{:},scb.h);
            
            obj.start_size = start_size/sum(start_size);
            obj.alg.(dim_name) = [obj.start_size(1) 5 obj.start_size(2)];
            obj.alg.realign();
        end
        
        function setElement1(obj,element)
            i = obj.elementi2algi(1);
            obj.alg.addElement(i{:},element);
        end
        
        function setElement2(obj,element)
            i = obj.elementi2algi(3);
            obj.alg.addElement(i{:},element);
        end
    end
    
    methods(Access = 'protected')
        function ai = elementi2algi(obj,i)
            switch obj.type
                case 'h'
                    ai = {1 i};
                case 'v'
                    ai = {i 1};
            end
        end
    end
end