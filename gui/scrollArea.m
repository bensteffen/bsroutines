function scrollArea(I,J)

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
    % Date: 2012-11-19 10:55:12
    % Packaged: 2017-04-27 17:58:26
param.panel.height = I/4;
param.panel.pos = 1-param.panel.height;
param.slider.min = 0;
param.slider.max = param.panel.height;
param.children.pos = cell(I,J);

hdl.main =   figure('WindowScrollWheelFcn',@scroll);
hdl.slider = uicontrol('Parent',hdl.main,...
                       'Style','slider',...
                       'Units','normalized',...
                       'Position',[.95 0 .05 1],...
                       'Min',param.slider.min,...
                       'Max',param.slider.max,...
                       'SliderStep',[param.panel.height/100 param.panel.height/10],...
                       'Value',param.panel.height,...
                       'Callback',@scroll...
                       );
hdl.panel =    uipanel('Parent',hdl.main,...
                       'Position',[0 param.panel.pos 0.95 param.panel.height]...
                       );
hdl.cells = zeros(I,J);
                   
param.margin.lx = 0.1;
param.margin.rx = 0.05;
param.margin.uy = 0.01;
param.margin.ly = 0.01;

for j = 1:J
    for i = 1:I
        dx = (1 - param.margin.lx - param.margin.rx)/J;
        dy = (1 - param.margin.uy - param.margin.ly)/I;
        x0 = (j-1)*dx + param.margin.lx;
        y0 = 1 - i*dy - param.margin.uy;
        param.children.pos{i,j} = [x0 y0 dx dy];
        hdl.cells(i,j) = uicontrol('Parent',hdl.panel,'Style','text','String',num2str(i*j),'Units','normalized','Position',param.children.pos{i,j});
    end
end

    function scroll(hd,event_data)
        switch hd
            case hdl.slider
                slider_value = get(hdl.slider,'Value');
            case hdl.main
                scr_change = event_data.VerticalScrollCount*event_data.VerticalScrollAmount/50;
                slider_value = get(hdl.slider,'Value') - scr_change;
                if slider_value < param.slider.min
                    slider_value = param.slider.min;
                elseif slider_value > param.slider.max
                    slider_value = param.slider.max;
                end
                set(hdl.slider,'Value',slider_value);
        end
        setPanelPos(slider2pos(slider_value));
    end

    function setPanelPos(value)
        pp = get(hdl.panel,'Position');
        param.panel.pos = value;
        pp(2) = param.panel.pos;
        set(hdl.panel,'Position',pp);
    end

    function panel_pos = slider2pos(slider_value)
        panel_pos = 1 - slider_value;
    end
end