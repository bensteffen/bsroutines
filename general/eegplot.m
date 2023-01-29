function ah = eegplot(x,y)

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
    % Date: 2014-07-03 20:09:58
    % Packaged: 2017-04-27 17:58:07
[n,chn] = size(y)
fh = figure('Color','w','Units','normalized');

apos = rasterPositions([chn 1],[0.1 0.05]);
apos(:,4) = apos(:,4)*2;
apos(:,2) = apos(:,2) - 0.05;
ah = zeros(chn,1);

ylim = max(abs([min(y) max(y)]));
ylim = [-ylim ylim];

for i = 1:chn
    ah(i) = axes();
    plot(ah(i),x,y(:,i),'LineWidth',2,'Color',[0.5 0.5 0.5],'LineStyle','--');
    set(ah(i),'Position',apos(i,:),'Visible','off','Color','none','Xlim',minmax(x),'YLim',ylim);
%     text(apos)
end