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


function nii_to_png(data, ziel, rotate, zerofill, threshold)

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
    % Packaged: 2017-04-27 17:58:37
    if ~isdir(ziel)
        mkdir(ziel)
    end    
    img = data.img;
    va = data.hdr.dime.pixdim(2);
    vb = data.hdr.dime.pixdim(3);
    vc = data.hdr.dime.pixdim(4);
    
    max_intens = max(max(max(img)));
    max_intens = double(max_intens);
    S = size(img);
    
    if nargin < 5
        threshold = max_intens;
    end    
    img(img > threshold) = threshold;
    
    for k = 1:3
        for i = 1:S(k)
            if i < 10
                zahlstr = ['00' num2str(i)];
            elseif i < 100
                zahlstr = ['0' num2str(i)];
            else
                zahlstr = num2str(i);
            end   
            
            switch k
                case 1
                    namestr = 'rechts-links';
                    B = double(squeeze(img(i,:,:)));
                    v1 = vb;
                    v2 = vc;
                case 2
                    namestr = 'hinten-vorne';
                    B = double(squeeze(img(:,i,:)));
                    v1 = va;
                    v2 = vc;
                case 3
                    namestr = 'unten-oben';
                    B = double(squeeze(img(:,:,i)));
                    v1 = va;
                    v2 = vb;
            end        
            fB = fft(fft(B)');
            fB = fftshift(fB);
            L1 = size(B,1);
            L2 = size(B,2);              

%##################### Versuch eines Rauschfilters ########################            
%                 mspalte = mean(B,1);
%                 mzeile = mean(B,2);
%                 maxz = max(mzeile);
%                 maxs = max(mspalte);
%                 z_grenze = 0.1*maxz;
%                 s_grenze = 0.1*maxs;
%                 s_aus = find(mspalte > s_grenze);
%                 x1_aus = s_aus(1);
%                 x2_aus = s_aus(end);
%                 z_aus = find(mzeile > z_grenze);
%                 y1_aus = z_aus(1);
%                 y2_aus = z_aus(end);
%                 Baus = B;
%                 Baus(y1_aus:y2_aus, x1_aus:x2_aus) = 0;
%                 mask = zeros(L1,L2);
%                 mask(y1_aus:y2_aus, x1_aus:x2_aus) = 1;
%                 sBaus = [B(:, 1:x1_aus) B(:, x2_aus:L2)];
%                 ms = mean(sBaus,2);
%                 zBaus = [B(1:y1_aus,:); B(y2_aus:L1,:)];
%                 mz = mean(zBaus,1);
%                 Rs = zeros(L1,L2);
%                 Rz = zeros(L1,L2);                
%                 for s = 1:L2
%                     Rs(:,s) = ms;
%                 end
%                 for z = 1:L1
%                     Rz(z,:) = mz;
%                 end    
%                 R = (Rs + Rz)./2;
%                 B = B - R;
%                 B(B < 0) = 0;
%                 B = B.*mask;
%##########################################################################

            if L1 > L2
                L1neu = L1;
                L2neu = round((v2/v1)*L2);
            elseif L2 > L1
                L1neu = round((v1/v2)*L1);
                L2neu = L2;
            else
                if v1 > v2
                    L1neu = round((v1/v2)*L1);
                    L2neu = L2;
                elseif v2 > v1
                    L1neu = L1;
                    L2neu = round((v2/v1)*L2);
                else
                    L1neu = L1;
                    L2neu = L2;
                end    
            end        

            fBskal = zeros(L2neu, L1neu);
            x1 = round((L1neu - L1)/2) + 1;
            x2 = x1 + L1;
            y1 = round((L2neu - L2)/2) + 1;
            y2 = y1 + L2;
            fBskal(y1:y2 - 1, x1:x2 - 1) = fB;

            L1zero = L1neu*zerofill;
            L2zero = L2neu*zerofill;
            fBzero = zeros(L2zero, L1zero);

            x1 = round((L1zero - L1neu)/2) + 1;
            x2 = x1 + L1neu;
            y1 = round((L2zero - L2neu)/2) + 1;
            y2 = y1 + L2neu;        
            fBzero(y1:y2 - 1, x1:x2 - 1) = fBskal;

            tempmax = max(max(B));
            if tempmax > max_intens
                max_intens = tempmax;
            end    

            B = abs(ifft(ifft(fBzero)'));
            B = power(B, 1/2);
            if max_intens < max(max(B))
                max_intens = max(max(B));
            end    
            B = (B./sqrt(threshold)).*255;
            B = uint8(B);

            if i == 1
                disp(' '); disp(' ');
                disp(['########################## ' namestr ' ##########################']);
                disp(' ');
                disp(['Pixelgröße: ' num2str(v1) 'mm x ' num2str(v2) 'mm']);
                disp(' ');
                disp(['Ursprüngliche Auflösung: ' num2str(L1) 'x' num2str(L2)]);
                disp(' ');
                disp(['Skaliere auf: ' num2str(L1neu) 'x' num2str(L2neu)]);     
                disp(' ');
                disp(['Dimension des ursprünglichen k-Raums: ' num2str(size(fB,1)) 'x' num2str(size(fB,2))]);
                disp(' ');
                disp(['Dimension des k-Raums nach Zerofilling: ' num2str(size(fBzero,1)) 'x' num2str(size(fBzero,2))]);
                disp(' ');
                disp(['Neue Auflösung des Bildes: ' num2str(size(B,1)) 'x' num2str(size(B,2))]);
                disp(' ');
                disp('##################################################################');
            end

            switch rotate
                case 0
                    imwrite(B, [ziel filesep namestr '_' zahlstr '.png'], 'bitdepth', 8);
                case 1    
                    imwrite(rot90(B), [ziel filesep namestr '_' zahlstr '.png'], 'bitdepth', 8);
                case 2
                    imwrite(rot90(rot90(B)), [ziel filesep namestr '_' zahlstr '.png'], 'bitdepth', 8);
                case 3
                    imwrite(rot90(rot90(rot90(B))), [ziel filesep namestr '_' zahlstr '.png'], 'bitdepth', 8);
            end        
         end
     end
    disp(' ');
    disp(['Höchster Wert im Datensatz: ' num2str(max_intens)]);
    disp(' ');  disp(' ');     
end    





