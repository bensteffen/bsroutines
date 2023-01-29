function [Y,weighted_f] = gabor(X,f,sigma,sample_rate)

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
    % Date: 2015-03-19 15:08:35
    % Packaged: 2017-04-27 17:58:10
tau = (-4*sigma:1/sample_rate:4*sigma)';

hgauss = (1/sigma*sqrt(2*pi)) * exp(-tau.^2/(2*sigma^2));

f = f(:)';
Y = zeros(size(X,1),length(f));
for j = 1:length(f)
    Y(:,j) = conv(X,hgauss.*exp(1i*2*pi*f(j)*tau),'same');
end
Y = sqrt(Y.*conj(Y));

Ynorm = Y./repmat(sum(Y,2),[1 length(f)]);
weighted_f = sum(Ynorm.*repmat(f,[size(Y,1) 1]),2);