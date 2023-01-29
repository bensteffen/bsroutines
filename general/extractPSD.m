function psd = extractPSD(X,frq_win,sampling_rate,window_function)

    % psd = extractPSD(frq_win,window_function)
    %
    % --- INTPUT ---
    % Extracts the PSD in a given frequency window. The paths of the NIRS files
    % can be listed in the text file "psd_files.txt".
    %
    %         frq_win: two element vector containing the boundaries (in Hz) of
    %                  the frequency window, e.g. [0.03 0.1].
    % window_function: String specifying the window function to be used for
    %                  extraction (Schroeter used 'hanning'). Choose 'flat' to
    %                  use no window function. If the function is called
    %                  without this input, 'hanning' will be used.
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
    % Date: 2016-12-15 16:37:43
    % Packaged: 2017-04-27 17:58:08

% --- OUTPUT ---
%             psd: If all given NIRS files has same channel number psd will
%                  be a (file number x channel number) matrix. If the given
%                  NIRS data sets have different channel numbers psd will
%                  be a (file number x 1) cell array containing the psd
%                  vectors with the channel-wise psd.
%
% Before you use this function the first time, the folder containing this
% m-file must be set to a MatLab path (use "Set Path" enviroment).
% To use the function, first set the file names in the "psd_files.txt".
% Then type to the MatLab console:
%       psd = extractPSD([0.03 0.1]);
% or:
%       psd_flat = extractPSD([0.03 0.1],'flat');
% to use no window function. The result will be appear in the MatLab
% workspace named "psd", "psd_flat", respectively.


if nargin < 4
    window_function = 'hanning';
end

N = size(X,1);
chn = size(X,2);
fmax = sampling_rate/2;
% df = 2*fmax/N;
% frq_axis = (0:df:fmax-df)';
% Nft = length(frq_axis);

Nft = floor(N/2);
df = fmax/Nft;
frq_axis = linspace(df,fmax,Nft)';

switch window_function
    case 'flat'
        win = ones(N,chn);
    case 'hanning'
        win = 0.5*(1-cos( 2*pi*(0:N-1)/(N-1) ))';
        win = repmat(win,[1 chn]);
end

Xft = fft(X.*win);
Xft = Xft(1:Nft,:);
Xft = abs(Xft);
Xft = Xft ./ repmat(sum(Xft),[Nft 1]);
% figure; semilogx(frq_axis,mean(Xft,2));

psd = zeros(size(frq_win,1),size(Xft,2));
for i = 1:size(frq_win,1)
    fwin = frq_axis >= frq_win(i,1) & frq_axis < frq_win(i,2);
% version 1
%     psd(i,:) = sum(Xft(fwin,:));
% version 2
    fmask = repmat(frq_axis,[1 size(Xft,2)]);
    fmask(~fwin,:) = 0;
    psd(i,:) = sum(fmask.*Xft);
end