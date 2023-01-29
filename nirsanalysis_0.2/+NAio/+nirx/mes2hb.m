function [hb, hbo, hbt] = mes2hb(mesData, waveLength, baseline)
    % function [hb, hbo, hbt] = mes2hb(mesData, waveLength, baseline)
    %
    % mesData: Nx2 matrix.  1st column: measurement data for ~700nm, 2nd for
    %   ~830 nm.
    % waveLength: an array of size 2, the exact wavelengths of measurement.
    % The first element is wavelenth for 700nm, the second for 830nm.
    % baseline: array of size 2, the onset and offset of the baseline. unit is
    % not second, but simply index.
    %
    % hb, hbo, hbt: concentration of deoxy-hb, oxy-hb and total.
    %
    % Note: the baseline part of the data is removed from hb, hbo and hbt.  So
    % the length of these returned variables are less than the mesData.
    %
    % Example:
    %   hb, hbo, hbt]=mes2hb(mes, [701.2 831.6], [1 100]);
    %
    % Xu Cui
    % revised 2008-5-7
    % 2007-10-02
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
    % Date: 2016-05-10 16:46:08
    % Packaged: 2017-04-27 17:58:51

load(fullfile(fileparts(mfilename('fullpath')),'all_e_coef.mat'));
e_coef = all_e_coef;

wlen_700     = waveLength(1);
wlen_830     = waveLength(2);
data_fit_700 = mean(mesData([baseline(1):baseline(2)],1));
data_fit_830 = mean(mesData([baseline(1):baseline(2)],2));

eoxy_700 = find_e(wlen_700, 'oxy', e_coef);
eoxy_830 = find_e(wlen_830, 'oxy', e_coef);
edeo_700 = find_e(wlen_700, 'deoxy', e_coef);
edeo_830 = find_e(wlen_830, 'deoxy', e_coef);

a_700 = zeros(1, size(mesData,1));
a_830 = zeros(1, size(mesData,1));

pos = find(sign(mesData(:, 1)) * data_fit_700 > 0);
a_700(pos) = log(data_fit_700./mesData(pos,1));

pos = find(sign(mesData(:, 2)) * data_fit_830 > 0);
a_830(pos) = log(data_fit_830./mesData(pos,2));

hb = zeros(size(mesData,1),1);
hbo = zeros(size(mesData,1),1);
hbt = zeros(size(mesData,1),1);

%****** Oxy Hb ******
if ((eoxy_700*edeo_830 - eoxy_830*edeo_700)~=0)
	hbo = (a_700*edeo_830 - a_830*edeo_700)/(eoxy_700*edeo_830 - eoxy_830*edeo_700);
end;

%****** Deoxy Hb ******
if ((edeo_700*eoxy_830 - edeo_830*eoxy_700)~=0);
	hb = (a_700*eoxy_830 - a_830*eoxy_700)/(edeo_700*eoxy_830 - edeo_830*eoxy_700);
end

hbt = hbo + hb;
  
% % % % % % % % % % hb(baseline(1):baseline(2)) = [];
% % % % % % % % % % hbo(baseline(1):baseline(2)) = [];
% % % % % % % % % % hbt(baseline(1):baseline(2)) = [];
hb = hb';
hbo = hbo';
hbt = hbt';

%%
% lookup coefficient from a table.  If not exist, do interpolation
function e = find_e(waveLength, oxydeoxy, table)
if(strcmp(oxydeoxy, 'oxy'))
    col = 3;
elseif(strcmp(oxydeoxy, 'deoxy'))
    col = 2;
else
    error('You need to specify deoxy or oxy');
end

l = floor(waveLength);
u = floor(waveLength) + 1;

lc = table(find(table(:,1)==l),col);
uc = table(find(table(:,1)==u),col);

e = (uc - lc) / (u - l) * (waveLength - l) + lc;
return;