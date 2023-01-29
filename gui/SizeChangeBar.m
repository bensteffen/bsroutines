classdef SizeChangeBar < GuiFigureElement
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
    % Date: 2017-03-22 11:00:10
    % Packaged: 2017-04-27 17:58:25
    methods
        function obj = SizeChangeBar(type,guifig,alignment)
            obj@GuiFigureElement([type 'size_changer'],guifig);
            obj.alignment = alignment;
            obj.size_changing = false;
            switch lower(type)
                case 'h'
                    obj.dim_name = 'widths';
                    obj.dim_index = 1;
                    obj.pointer_shape = 'left';
                    obj.delta_sign = 1;
                case 'v'
                    obj.dim_name = 'heights';
                    obj.dim_index = 2;
                    obj.pointer_shape = 'top';
                    obj.delta_sign = -1;
                otherwise
                    error('SizeChangeBar(): Type must be "h" or "v"');
            end
        end
        
        function update(obj)
            evmodel = obj.models.entry('figure_events');
            drag_on = evmodel.getState('drag_mode');
            drag_on = ifel(isempty(drag_on),false,drag_on);
            if obj.size_changing || any(strcmp(evmodel.getState('mouse_over_elements'),obj.id))
                set(gcf,'Pointer',obj.pointer_shape);
                if drag_on
                    obj.size_changing = true;
                    d = evmodel.getState('signal_data');
                    delta = d.curr_pointer_location - d.last_pointer_location;
                    
                    alg_pixos = getpixelposition(nexthandle(obj.alignment));
%                     alg_pixos = childpixelposition(gui(obj.alignment));
                    x0 = obj.alignment.(obj.dim_name);
                    x = x0([1 3]);
                    x = x/sum(x);                    
                    delta = delta(obj.dim_index)/alg_pixos(obj.dim_index+2);
                    s = obj.delta_sign;
                    x(1) = max(min(x(1)+s*delta,0.95),0.05);
                    x(2) = max(min(x(2)-s*delta,0.95),0.05);
                    x0([1 3]) = x;
                    obj.alignment.(obj.dim_name) = x0;
                    obj.alignment.realign();
                else
                    obj.size_changing = false;
                end
            else
                set(gcf,'Pointer','arrow');
            end
        end
    end
    
    properties(Access = 'protected')
        alignment;
        size_changing;
        dim_name;
        dim_index;
        pointer_shape;
        delta_sign;
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            set(obj.h,'BackgroundColor',[0.5 0.5 0.5],'Parent',obj.alignment.h);
        end
    end
end