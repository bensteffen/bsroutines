function [h,alg] = commonxaxis(n,left_margin,right_margin)

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
    % Date: 2017-03-16 14:23:48
    % Packaged: 2017-04-27 17:58:26
h = objectmx([n 1],'axes');
set(h,'LineWidth',2,'Box','on');

dummy_props = {'Visible','off'};

m = 50;

% set(gcf,'Position',[100 100 300 800])
alg = MatrixAlignment(gcf);
alg.addElement(1,1,plainpanel(dummy_props{:}),[m 1]);
alg.addElement(n+2,1,plainpanel(dummy_props{:}),[m 1]);
for i = 1:n
    alg.addElement(i+1,1,plainpanel(dummy_props{:}),[1 m]);
    alg.addElement(i+1,2,h(i)); 
    alg.addElement(i+1,3,plainpanel(dummy_props{:}),[1 m]);
%     ylabs = get(h(i),'YTickLabels');
%     ylabs{1} = ''; ylabs{end} = '';
%     set(h(i),'YTickLabels',ylabs)
    
%     if i < n
% %         xlabs = get(ax,'XTickLabels');
% %         xlabs{1} = ''; xlabs{end} = '';
%         set(h(i),'XTickLabels',{});
%     end
    if i < n
        set(h(i),'XTick',[]);
    end
end