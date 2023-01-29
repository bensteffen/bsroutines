function Y = pcaglobal(X,si)
    %UNTITLED4
    %  Mit dieser Funktion kann man die globale Komponente aus einem Signal
    %  mittels PCA und spacial smoothing herausrechnen. CAVE bei globalen
    %  neuronalen Activierungen werden diese rausgeworfen. Zudem können
    %  negative artifizielle Aktivierungen eingebaut werden. Dies hängt vor
    %  allem vom Kernelfilter und dessen Steurung (50 in diesem Fall) ab.
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
    % Date: 2016-06-20 17:05:42
    % Packaged: 2017-04-27 17:58:37

%Siehe Artikel Zhang Noah & Hirsch 2016 Separation of the global and local components in fNIRS using PCA spatial filtering.

    [coef,score]=pca(X); %PCA 
    coefGauss=imgaussfilt(coef,si);%Kernelfilter über Ladungsmatrix
    dGlobal=score*coefGauss';
    Y=X-dGlobal;