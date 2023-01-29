classdef ScrollPanel < GuiFigureElement    
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
    % Date: 2017-03-13 13:05:14
    % Packaged: 2017-04-27 17:58:24
    properties(SetAccess = 'protected')
        scroll_panel;
        alg_panel;
    end
    
    properties(Access = 'protected')
        wslider;
        hslider;
    end

    methods
        function obj = ScrollPanel(id,parent,obj2scroll)
            if nargin < 2
                parent = GuiFigure();
            end
            if nargin < 1
                id = 'scroll_panel';
            end
            obj@GuiFigureElement(id,parent);
            
            obj.alg_panel = uipanel('Units','normalized','BorderType','none','Position',[0 0 1 1],'Visible','on');
            obj.scroll_panel = uipanel('Parent',obj.alg_panel,'Units','pixels','BorderType','none','BackgroundColor','w','Visible','on');
            
            obj.addProperty(Input.ElementItem('scrollbar_width',20,20,Input.Test(@(x) isint(x) & x > 0,'Scrollbar width must be an interger > 0')), ...
                            @(o) o.update());
            obj.addProperty(Input.ElementItem('scroll_size',[800 800],[800 800],Input.Test(@(x) isnumeric(x) & numel(x) == 2 & all(isint(x)) & all(x >= -1),'Scroll size must be a two-element vector with elements >= -1')), ...
                            @(o) o.update());
            obj.addProperty(Input.ElementItem('obj2scroll',[],[],Input.Test(@(x) isempty(x) || ishandle(x),'Object to scroll must be a handle')), ...
                            @(o) set(o.getProperty('obj2scroll'),'Parent',obj.scroll_panel,'Units','normalized'));
            
            alg = MatrixAlignment(parent.figh);
            set(alg,'BackgroundColor',[0.9400 0.9400 0.9400]);
            alg.addElement(1,1,obj.alg_panel);
            
            
            slider_props = {'Parent',obj.h...
                           ,'Style','slider' ...
                           ,'Units','pixels' ...
                           ,'Min',0 ...
                           ,'Max',1 ...
                           ,'SliderStep',[1/100 1/10] ...
                           ,'Callback',@obj.userScrolling...
                           };
            obj.wslider = uicontrol(slider_props{:},'Value',0);
            obj.hslider = uicontrol(slider_props{:},'Value',1);
            
            alg.addElement(2,1,obj.wslider);
            alg.addElement(1,2,obj.hslider);
            
            alg.widths = [1 20];
            alg.heights = [1 20];
            alg.realign();
            
            obj.h = alg;
            set(obj.alg_panel,'SizeChangedFcn',@obj.update);
                        
            if nargin > 2
                obj.setProperty('obj2scroll',obj2scroll);
            end
                        
            obj.update();
        end
        
        function update(obj,h,d)
            psize = getpixelposition(obj.alg_panel);
%             b = obj.getProperty('scrollbar_width');
            scroll_size = obj.getProperty('scroll_size');
            scroll_size(scroll_size < 0) = psize([false false scroll_size < 0]);
            
            evmodel = obj.models.entry('figure_events');
            if evmodel.isActive('mouse_wheel') && any(strcmp(obj.id,evmodel.getState('mouse_over_elements')))
%             if evmodel.isActive('mouse_wheel') && any(strcmp(obj.id,evmodel.getState('mouse_down_elements')))
                mouse_scrsize = evmodel.getState('signal_data').VerticalScrollCount;
                slider_val = get(obj.hslider,'Value');
                new_slider_val = slider_val - mouse_scrsize*40/scroll_size(2);
                new_slider_val= ifel(new_slider_val < 0,0,min(1,new_slider_val));
                set(obj.hslider,'Value',new_slider_val);
            end
            
            wrange = max(0,scroll_size(1)-psize(3));
            hrange = max(0,scroll_size(2)-psize(4));
            
            if isvalid(obj.wslider) && isvalid(obj.hslider)
                wval =     get(obj.wslider,'Value'); wval = ifel(isempty(wval),0,wval);
                hval = 1 - get(obj.hslider,'Value'); hval = ifel(isempty(hval),0,hval);
            
                scroll_pos = round([0 psize(4)-scroll_size(2) scroll_size]);
                scroll_pos = round(scroll_pos + [-wval*wrange hval*hrange 0 0]);

                set(obj.scroll_panel,'Position',scroll_pos);
                flag = flag2onoff(wrange>0);
                set(obj.wslider,'Enable',flag,'Visible',flag);
                flag = flag2onoff(hrange>0);
                set(obj.hslider,'Enable',flag,'Visible',flag);
            end
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            
        end
        
        function updateUiElements(obj)
        end
        
        function userScrolling(obj,h,d)
            obj.update();
        end
    end
end