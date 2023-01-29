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


function axh = plot1Axis(t,D, roi, data_name, style, tag)
    
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
    % Date: 2014-01-31 13:08:28
    % Packaged: 2017-04-27 17:58:16
    cla;
    lh_ch_d = zeros(length(D)*length(roi),3);
    counter = 1;
    time_start = zeros(1,length(D));
    time_end = zeros(1,length(D));
    for d = 1:length(D)
        time_axis = t{d};
        data = D{d};
        for c = 1:length(roi)
            switch tag
                case 'Channel'
                    h = plot(time_axis,data(:,roi(c)),style{d});
                case 'Subject'
                    h = plot(time_axis,data(:,c),style{d});
            end
            lh = get(gca,'Children');
            lh_new = lh(1);
            lh_ch_d(counter,:) = [lh_new roi(c) d];
            counter = counter + 1;
            set(lh_new,'ButtonDownFcn',@channelClicked);
            hold on;
        end
        time_start(d) = time_axis(1);
        time_end(d) = time_axis(end);
    end
    set(gca,'XLim',[min(time_start) max(time_end)]);
    
    x_lim = get(gca,'XLim');
    y_lim = get(gca,'YLim');
    xL = x_lim(2) - x_lim(1);
    yL = y_lim(2) - y_lim(1);
    text_pos = [x_lim(1)+0.05*xL y_lim(1)+0.95*yL];
    text_handle = text(text_pos(1),text_pos(2),'');
    set(text_handle,'Interpreter','latex');
    
    last_clicked = [];
    
    if nargout > 0
        axh = gca;
    end
    
    function channelClicked(h, event_data)
        lh_index = find(h == lh_ch_d(:,1));
        clicked_ch = lh_ch_d(lh_index,2);
        name_index = lh_ch_d(lh_index,3);
        disp_name = data_name{name_index};
        disp_name = strrep(disp_name,'_','\_ ');
        set(text_handle,'string', [tag ' ' num2str(clicked_ch) ' (' disp_name ') was clicked.']);
        x_lim = get(gca,'XLim');
        y_lim = get(gca,'YLim');
        xL = x_lim(2) - x_lim(1);
        yL = y_lim(2) - y_lim(1);
        text_pos = [x_lim(1)+0.05*xL y_lim(1)+0.95*yL];
        set(text_handle,'Position',text_pos);
        lines = lh_ch_d(lh_ch_d(:,2) == clicked_ch,1);
        for i = lines
            set(i,'LineWidth',2.5);
        end
        if ~isempty(last_clicked)
            for i = last_clicked
                set(i,'LineWidth',1);
            end
        end
        last_clicked = lines;
    end
end