function [markers,hs] = find1020markers(head_surface_vxs,nasion,inion,pre_aure_r,pre_aure_l)

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
    % Date: 2015-11-20 13:32:05
    % Packaged: 2017-04-27 17:57:55
markers = containers.Map;

% nasion - inion
[s,b,s23] = slicevoxels(head_surface_vxs,nasion,[0 0 1; inion-nasion],0.5);% scatter3(s(:,1),s(:,2),s(:,3),'g.');
s2 = s23(:,1:2);

[i_nas,i_ini] = deal(find2di(nasion,s2,b),find2di(inion,s2,b));
d_nas_ini = distalongcurve(s2,i_nas,i_ini,-1,false);
fprintf('nasion-inion distance = %.1f cm\n',d_nas_ini/10);

markers('nasion') = (b'*s23(i_nas,:)')';
markers('inion')  = (b'*s23(i_ini,:)')';
markers('Fpz') = (b'*s23(pointalongcurve(s2,i_nas,0.1*d_nas_ini,-1),:)')';
markers('Fz') = (b'*s23(pointalongcurve(s2,i_nas,0.3*d_nas_ini,-1),:)')';
markers('Cz') = (b'*s23(pointalongcurve(s2,i_nas,0.5*d_nas_ini,-1),:)')';
markers('Pz') = (b'*s23(pointalongcurve(s2,i_ini,0.3*d_nas_ini,1),:)')';
markers('Oz') = (b'*s23(pointalongcurve(s2,i_ini,0.1*d_nas_ini,1),:)')';

% head circumference
[s,b,s23] = slicevoxels(head_surface_vxs,markers('Fpz'),[1 0 0; inion-markers('Fpz')],0.5); hold on;% scatter3(s(:,1),s(:,2),s(:,3),'g.');
s2 = s23(:,1:2);

i_fpz = find2di(markers('Fpz'),s2,b);
i_ini = find2di(inion,s2,b);
hs = distalongcurve(s2,i_fpz,i_fpz,1,false);
% fprintf('head circumference = %.1f cm\n',hs/10);
hs_half = hs/2;

markers('Fp1') = (b'*s23(pointalongcurve(s2,i_fpz,0.1*hs_half,1),:)')';
markers('F7') = (b'*s23(pointalongcurve(s2,i_fpz,0.3*hs_half,1),:)')';
markers('T3') = (b'*s23(pointalongcurve(s2,i_fpz,0.5*hs_half,1),:)')';
markers('T5') = (b'*s23(pointalongcurve(s2,i_ini,0.3*hs_half,-1),:)')';
markers('O1') = (b'*s23(pointalongcurve(s2,i_ini,0.1*hs_half,-1),:)')';

markers('Fp2') = (b'*s23(pointalongcurve(s2,i_fpz,0.1*hs_half,-1),:)')';
markers('F8') = (b'*s23(pointalongcurve(s2,i_fpz,0.3*hs_half,-1),:)')';
markers('T4') = (b'*s23(pointalongcurve(s2,i_fpz,0.5*hs_half,-1),:)')';
markers('T6') = (b'*s23(pointalongcurve(s2,i_ini,0.3*hs_half,1),:)')';
markers('O2') = (b'*s23(pointalongcurve(s2,i_ini,0.1*hs_half,1),:)')';

% ear to ear

[s,b,s23] = slicevoxels(head_surface_vxs,pre_aure_r,[normvec(markers('Cz')-pre_aure_r); normvec(pre_aure_l-pre_aure_r)],0.5); %scatter3(s(:,1),s(:,2),s(:,3),'g.');
s2 = s23(:,1:2);

i_prear = find2di(pre_aure_r,s2,b);
i_preal = find2di(pre_aure_l,s2,b);

ear2ear = distalongcurve(s2,i_prear,i_preal,-1,false);

markers('T3') = (b'*s23(pointalongcurve(s2,i_prear,0.1*ear2ear,-1),:)')';
markers('C3') = (b'*s23(pointalongcurve(s2,i_prear,0.3*ear2ear,-1),:)')';

markers('T4') = (b'*s23(pointalongcurve(s2,i_preal,0.1*ear2ear,1),:)')';
markers('C4') = (b'*s23(pointalongcurve(s2,i_preal,0.3*ear2ear,1),:)')';

markers('F3') = markerCrossed('Fp1','C3','F7','Fz');
markers('F4') = markerCrossed('Fp2','C4','F8','Fz');

markers('P3') = markerCrossed('O1','C3','T5','Pz');
markers('P4') = markerCrossed('O2','C4','T6','Pz');


    function m = markerCrossed(p11,p12,p21,p22)
        [~,bb,ss23] = shortestSurfaceConnection(head_surface_vxs,markers(p11),markers(p12),-1); ss2 = ss23(:,1:2);
        ii = find2di(markers(p11),ss2,bb); jj = find2di(markers(p12),ss2,bb); dd = distalongcurve(ss2,ii,jj,-1,false);
        A = (bb'*ss23(pointalongcurve(ss2,ii,0.5*dd,-1),:)')';
        [~,bb,ss23] = shortestSurfaceConnection(head_surface_vxs,markers(p21),markers(p22),-1); ss2 = ss23(:,1:2);
        ii = find2di(markers(p21),ss2,bb); jj = find2di(markers(p22),ss2,bb); dd = distalongcurve(ss2,ii,jj,-1,false);
        B = (bb'*ss23(pointalongcurve(ss2,ii,0.5*dd,-1),:)')';

        m = nearestvoxel(mean([A;B]),head_surface_vxs);
    end


end




