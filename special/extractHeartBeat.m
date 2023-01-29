function [hrf,hramp] = extractHeartBeat(X,ppa_extr_method,sigma,deconv_flag)

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
    % Date: 2015-03-19 16:25:47
    % Packaged: 2017-04-27 17:58:35
    if nargin < 2
        ppa_extr_method = 'max';
    end

    if nargin < 3
        sigma = 3;
    end
    
    if nargin < 4
        deconv_flag = false;
%         deconv_flag = true;
    end
    
    [hrf,hramp] = deal(NaN(size(X)));
    f = 0.5:0.01:2;
    
    n = size(X,1);
    tau = sample2time(1:n,10)' - n/10/2;
    dc_sigma = 1*sigma;
    hgauss = (1/dc_sigma*sqrt(2*pi)) * exp(-tau.^2/(2*dc_sigma^2));

    chs = find(~any(isnan(X)));

    for j = chs
        y = gabor(X(:,j),f,sigma,10);
        switch ppa_extr_method
            case 'max'
                hramp(:,j) = max(y,[],2);
            case 'sum'
                hramp(:,j) = sum(y,2);
            case 'mean'
                hramp(:,j) = mean(y,2);
        end
        y = y./repmat(sum(y,2),[1 length(f)]);
        hrf(:,j) = sum(y.*repmat(f,[size(y,1) 1]),2);
        if deconv_flag
            hrf(:,j) = deconvgabor(hrf(:,j));
            hramp(:,j) = deconvgabor(hramp(:,j));
        end
    end

    function deconvx_ = deconvgabor(x_)
        deconvx_ = deconvlucy(x_,hgauss,10);
        deconvx_ = zscore(deconvx_)*std(x_) + mean(x_);
    end
end