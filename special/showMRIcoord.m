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


function showMRIcoord(data, x,y,z)

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
    % Date: 2012-01-20 19:38:34
    % Packaged: 2017-04-27 17:58:38
J = size(data,2)
K = size(data,3)

ci = z;
cj = J - x + 1;
ck = K - y + 1;

Bi = rot90(squeeze(data(ci,:,:))',2);
Bj = rot90(squeeze(data(:,cj,:)));
Bk = rot90(squeeze(data(:,:,ck)));

figure;
subplot(2,2,1); imagesc(Bj);
subplot(2,2,2); imagesc(Bi);
subplot(2,2,3); imagesc(Bk);

S = size(data);
Li = S(1);
Lj = S(2);
Lk = S(3);


B = squeeze(data(:,y,:)); % ???
B1 = zeros(Lk,Li);
for a = 1:Lk
    for b = 1:Li
        B1(a,b) = B(Li + 1 - b,Lk + 1 - a);
    end
end

B = squeeze(data(x,:,:)); % ???
B2 = zeros(Lk, Lj);
for a = 1:Lk
    for b = 1:Lj
        B2(a,b) = B(Lj + 1 - b, Lk + 1 - a);
    end
end

B = squeeze(data(:,:,z)); % ???
B3 = zeros(Lj, Li);
for a = 1:Lj
    for b = 1:Li
%         B3(a,b) = B(Lj + 1 - b, Li + 1 - a);
    end
end

figure;
subplot(2,2,1); imagesc(B1);
subplot(2,2,2); imagesc(B2);
subplot(2,2,3); imagesc(B3);


