function peakdata = intervalPeakDetection(X,interval,delta)

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
    % Date: 2012-10-31 17:38:32
    % Packaged: 2017-04-27 17:58:11
startI = interval(1);
endI = interval(2);

J = size(X,2);

peakdata.max.index = zeros(1,J);
peakdata.max.value = zeros(1,J);
peakdata.min.index = zeros(1,J);
peakdata.min.value = zeros(1,J);

for j = 1:J
    [maxVec minVec] = peakdet(X(startI:endI,j), delta);
    if ~isempty(maxVec)
        [~, max_i] = max(maxVec(:,2));
        maxVec = maxVec(max_i,:);
    else
        [maxVec(2) maxVec(1)] = max(X(startI:endI,j));
    end
    if ~isempty(minVec)
        [~, min_i] = min(minVec(:,2));
        minVec = minVec(min_i,:);                   
    else
        [minVec(2) minVec(1)] = min(X(startI:endI,j));
    end
    peakdata.max.index(j) = maxVec(1) + startI - 1;
    peakdata.max.value(j) = maxVec(2);
    peakdata.min.index(j) = minVec(1) + startI - 1;
    peakdata.min.value(j) = minVec(2);
end