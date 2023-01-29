function [fnirsMat_WaveletDenoised] = waveletDenoising(fnirsMat,waveletType,support,alphaThresh,percTreshWaveLev,shuffling);
    % Wavelet denoising of fNIRS data for detecting and removing transient artifacts such as head motion artifacts. Based on the paper
    % by Molavi & Dumont 2012 "Wavelet-based motion artifact removal for functional near-infrared spectroscopy"
    % Function requires Wavelab850 toolbox http://statweb.stanford.edu/~wavelab/). Standard parameters values (called by setting parameter to []) are
    % taken from this paper
    % INPUT: fnirsMat: n x m matrix of n time points and m channels fNIRS data
    %        waveletType:     type of wavelet used in Wavelab850 (cf. MakeONFilter.m),
    %                         i.e. either 'Haar', 'Beylkin', 'Coiflet', 'Daubechies', 'Symmlet', 'Vaidyanathan','Battle'. Standard: 'Daubechies'
    %       support:          support of the wavelet (cf. MakeONFilter.m). Standard: 10
    %       alphaThresh:      (Normal-Gaussian) probability below which a wavelet coefficient is treated as outlier. Standard: 0.1
    %       percTreshWaveLev: percentile threshold of wavelet levels above (between 0-1)
    %       which the outlier coefficients of a wavelet level are corrected
    %                         (i.e. set to 0): Standard 0.9
    %       shuffling:        = 1 = shuffling of time points before and
    %                         after denoising and final averaging over shuffles to reduce Gibbs artifacts (caution: very time-consuming computation);
    %                         = 0 = no shuffling. Standard: 0 (in paper = 1!)
    %OUTPUT:fnirsMat_WaveletDenoised: n x m matrix of n time points and m channels of wavelet denoised fNIRS data
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
    % Date: 2016-03-04 11:53:48
    % Packaged: 2017-04-27 17:58:47
if nargin < 6 || isempty(shuffling);
    shuffling = 0;
end;
if nargin < 5 || isempty(percTreshWaveLev);
    percTreshWaveLev = 0.9;
end
if nargin < 4 || isempty(alphaThresh);
    alphaThresh = 0.1;
end
if nargin < 3 || isempty(support);
    support = 10;
end
if nargin < 2 || isempty(waveletType);
    waveletType = 'Daubechies';
end
if nargin < 1 || isempty(fnirsMat);
    error('Enter at least some fNIRs data!');
end

plotFlag = 0; % this flag controls whether comparison of signals pre- / post wavelet denoising is plotted 1 vs 0

%-- create wavelet -------------------
QMF8 = WAV850orth.MakeONFilter(waveletType,support); % Daubechies wavelet with a support of 10 is used in paper

%----- pad data matrix with 0s to the next higher power of 2 --------------
nChannels = size(fnirsMat,2);
nSamples = size(fnirsMat,1);
expB2 = log(nSamples)/log(2);
expB2 = ceil(expB2);
nZeros = 2^expB2 - nSamples;
fnirsMat0Padded = [fnirsMat; zeros(nZeros,nChannels)];
fnirsMat_WaveletDenoised = NaN(nSamples,nChannels);

%--Implementation of probabilistic thresholding as described by Molavi & Dumont 2012: Assuming Gaussian wavelet coefficients in case of 
% BOLD related fNIRS signals, highly unlikely coefficients are treated as artifact-induced outliers and removed
for iCh = 1:nChannels;
    y  = fnirsMat0Padded(:,iCh)';    
    L = 1;
    n = length(y);
    if shuffling == 1;
        nShuffle = n;
        yDenoisedShuffled = NaN(n,n);
    else
        nShuffle = 1;
    end; 
    for iShuffle = 1:nShuffle;
        yShuffled = circshift(y,[0 iShuffle-1]);
        wcoef = WAV850orth.FWT_PO(yShuffled,L,QMF8) ;
        wcoefThresh = wcoef;
        [n,J] = WAV850orth.dyadlength(wcoef);       
        for j=(J-1):-1:L;
            wc = wcoef(WAV850orth.dyad(j));
            sigma = median(abs(wc)) / 0.6745;% variance estimated by median absolute deviation (robust to outliers, cf. Hoaglin et al 1983)
            prob_wc = 2 * (1 - normcdf(abs(wc)/sigma,0,1) );
            wcThresh = wc;
            wcThresh(prob_wc <= alphaThresh) = 0; 
            nOutlier(1,j) = sum(wcThresh == 0);
            wcoefThresh(WAV850orth.dyad(j)) = wcThresh;
        end      
        % find dilation levels above 90% outlier percentile to determine levels in
        % which outlier are corrected
        quantBoundary = quantile(nOutlier,percTreshWaveLev);
        levelsForCorr = find(nOutlier > quantBoundary);
        wcoefCorr = wcoef;
        for j = levelsForCorr;
            wcoefCorr(WAV850orth.dyad(j)) = wcoefThresh(WAV850orth.dyad(j));
        end;
        yDenoised  = WAV850orth.IWT_PO(wcoefCorr,L,QMF8);
        yDenoisedShuffled(iShuffle,:) = circshift(yDenoised,[0 -(iShuffle-1)]);% reverse Shuffleing before averaging
    end;
    yDenoised = mean(yDenoisedShuffled,1);
    fnirsMat_WaveletDenoised(1:nSamples,iCh) = yDenoised(1,1:nSamples);
end;

if plotFlag == 1;
    figure(99);clf;
    set(gcf,'Units','centimeters', 'OuterPosition', [1 1 30 25])
    mCh = repmat(mean(fnirsMat,1),[nSamples,1]);
    stdCh = repmat(std(fnirsMat,[],1),[nSamples,1]);
    pre = [(fnirsMat-mCh)./stdCh + repmat([0:nChannels-1]*6,[nSamples,1])];
    post = [(fnirsMat_WaveletDenoised-mCh)./stdCh + repmat([0:nChannels-1]*6,[nSamples,1])];
    h1 = plot([pre],'Color',[0 0 1]);hold on;
    h2 = plot(post,'Color',[0 0 0],'LineStyle','--');
    legend([h1(1),h2(1)],'original','wavelet denoised');
    axis([0 nSamples+10 min(min(pre)) max(max(pre))]);
    xlabel('time point (sample no)');
    ylabel('signal in differen channels(a.u.)');
    title('Comparison of fNIRS signals before and after wavelet denoising');
    box off;
    input('Press any button to proceed to next data set...')
end;

