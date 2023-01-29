%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 20-Jan-2012 19:38:34


function hout = frqplot(X,fs,log_flag,method)


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
    % Date: 2012-11-20 12:54:52
    % Packaged: 2017-04-27 17:58:10
if nargin < 3
    log_flag = 'no_log';
end
if nargin < 4
    method = 'fft';
end

switch method
    case 'fft'
        fX = fft(X);
        fX = fX.*conj(fX);
    case 'dct'
        fX = abs(dct(X)).^2;
end
f = getFrequency(method,size(fX,1),fs);
N = length(f);
J = size(fX,2);
fX = fX(1:N,:);
switch log_flag
    case 'log_frq'
        plot1Axis({f},{fX},1:J,{'spect.dens.'},{'r'},'Channel');
        set(gca,'XScale','log');
    case 'log_pwr'
        plot1Axis({f},{fX},1:J,{'spect.dens.'},{'r'},'Channel');
        set(gca,'YScale','log');
    case 'log_log'
        plot1Axis({f},{fX},1:J,{'spect.dens.'},{'r'},'Channel');
        set(gca,'XScale','log','YScale','log');
    case 'no_log'
        n = max(fX);
        plot1Axis({f},{sqrt(fX./repmat(n,[N 1]))},1:J,{'spect.dens.'},{'r'},'Channel');
    otherwise
        error(['Unknown logplot option ' log_flag]);
end

title('Spectrum');
xlabel('Frequency [Hz]');
ylabel('Power [a.u.]');

if nargout > 1
    hout = gca;
end