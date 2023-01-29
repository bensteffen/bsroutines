function XYZ = createVoxelSphericalShell(M, R, dR)

    % R = R;
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
    % Date: 2012-10-15 15:04:43
    % Packaged: 2017-04-27 17:58:39
dR = dR - 1;

f = R*10;

dPhi = 2*pi/f;
phi = 0:dPhi:2*pi-dPhi;

dTheta = pi/f;
theta = 0:dTheta:pi-dTheta;

dr = R/10;
r = R-dR:dr:R+dR;

XYZ = zeros(length(theta)*length(phi)*length(r),3);
c = 1;

for th_i = 1:length(theta)
    th = theta(th_i);
    sin_th = sin(th);
    cos_th = cos(th);
    for phi_i = 1:length(phi)
        ph = phi(phi_i);
        sin_ph = sin(ph);
        cos_ph = cos(ph);

        for r_i = 1:length(r)
            XYZ(c,:) = r(r_i)*[sin_th*cos_ph sin_th*sin_ph cos_th];
            c = c + 1;
        end
    end
end

XYZ = round(XYZ);
dim = findDimension(XYZ);
m = min(XYZ);
XYZ = transformToOrigin(XYZ) + 1;
XYZ = listIndex2voxel(unique(voxel2listIndex(XYZ,dim)),dim);
XYZ = transformCoordList(XYZ,[1 0 0 m(1); 0 1 0 m(2); 0 0 1 m(3); 0 0 0 1]) - 1;
XYZ = transformCoordList(XYZ,[1 0 0 M(1); 0 1 0 M(2); 0 0 1 M(3); 0 0 0 1]);