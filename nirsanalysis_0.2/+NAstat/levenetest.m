%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 08-Jun-2012 17:27:02


function p = levenetest(X)
    %Levene's Test for Homogeneity of Variances.
    %[In the Levene's test the data are transforming to yij = abs[xij - mean(xj)]
    %and uses the F distribution performing an one-way ANOVA using y as the
    %dependent variable (Brownlee, 1965; Miller, 1986)].
    %
    %   Syntax: function [Levenetest] = Levenetest(X,alfa)
    %
    %     Inputs:
    %          X - data matrix (Size of matrix must be n-by-2; data=column 1, sample=column 2).
    %       alpha - significance level (default = 0.05).
    %     Outputs:
    %          - Sample variances vector.
    %          - Whether or not the homoscedasticity was met.
    %
    %    Example: From the example 10.1 of Zar (1999, p.180), to test the Levene's
    %             homoscedasticity of data with a significance level = 0.05.
    %
    %                                 Diet
    %                   ---------------------------------
    %                       1       2       3       4
    %                   ---------------------------------
    %                     60.8    68.7   102.6    87.9
    %                     57.0    67.7   102.1    84.2
    %                     65.0    74.0   100.2    83.1
    %                     58.6    66.3    96.5    85.7
    %                     61.7    69.8            90.3
    %                   ---------------------------------
    %
    %           Data matrix must be:
    %            X=[60.8 1;57.0 1;65.0 1;58.6 1;61.7 1;68.7 2;67.7 2;74.0 2;66.3 2;69.8 2;
    %            102.6 3;102.1 3;100.2 3;96.5 3;87.9 4;84.2 4;83.1 4;85.7 4;90.3 4];
    %
    %     Calling on Matlab the function:
    %             Levenetest(X)
    %
    %       Answer is:
    %
    % The number of samples are: 4
    %
    % ----------------------------
    % Sample    Size      Variance
    % ----------------------------
    %   1        5         9.3920
    %   2        5         8.5650
    %   3        4         7.6567
    %   4        5         8.3880
    % ----------------------------
    %
    % Levene's Test for Equality of Variances F=0.0335, df1= 3, df2=15
    % Probability associated to the F statistic = 0.9914
    % The associated probability for the F test is larger than 0.05
    % So, the assumption of homoscedasticity was met.
    %
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
    % Date: 2012-06-08 17:27:02
    % Packaged: 2017-04-27 17:58:53

%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  April 11, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). Levenetest: Levene's test for
%    homogeneity of variances. A MATLAB file. [WWW document]. URL http://www.mathworks.com/
%    matlabcentral/fileexchange/loadFile.do?objectId=3375&objectType=FILE
%
%  References:
% 
%  Brownlee, K. A. (1965) Statistical Theory and Methodology in Science
%           and Engineering. New York: John Wiley & Sons.
%  Miller, R. G. Jr. (1986) Beyond ANOVA, Basics of Applied Statistics.  
%           New York: John Wiley & Sons.
%  Zar, J. H. (1999), Biostatistical Analysis (2nd ed.).
%           NJ: Prentice-Hall, Englewood Cliffs. p. 180. 
%


Y=X;
k=max(Y(:,2));

%Levene's Procedure.
n=[];s2=[];Z=[];
indice=Y(:,2);
for i=1:k
   Ye=find(indice==i);
   eval(['Y' num2str(i) '=Y(Ye,1);']);
   eval(['mY' num2str(i) '=mean(Y(Ye,1));']);
   eval(['n' num2str(i) '=length(Y' num2str(i) ') ;']);
   eval(['s2' num2str(i) '=(std(Y' num2str(i) ').^2) ;']);
   eval(['Z' num2str(i) '= abs((Y' num2str(i) ') - mY' num2str(i) ');']);
   eval(['xn= n' num2str(i) ';']);
   eval(['xs2= s2' num2str(i) ';']);
   eval(['x= Z' num2str(i) ';']);
   n=[n;xn];s2=[s2;xs2];Z=[Z;x];
end

Y=[Z Y(:,2)];

C=(sum(Y(:,1)))^2/length(Y(:,1)); %correction term.
SST=sum(Y(:,1).^2)-C; %total sum of squares.
dfT=length(Y(:,1))-1; %total degrees of freedom.

indice=Y(:,2);
for i=1:k
   Ye=find(indice==i);
   eval(['A' num2str(i) '=Y(Ye,1);']);
end

A=[];
for i=1:k
   eval(['x =((sum(A' num2str(i) ').^2)/length(A' num2str(i) '));']);
   A=[A,x];
end

SSA=sum(A)-C; %sample sum of squares.
dfA=k-1; %sample degrees of freedom.
SSE=SST-SSA; %error sum of squares.
dfE=dfT-dfA; %error degrees of freedom.
MSA=SSA/dfA; %sample mean squares.
MSE=SSE/dfE; %error mean squares.
F=MSA/MSE; %F-statistic.
v1=dfA;df1=v1;
v2=dfE;df2=v2;

p = 1 - fcdf(F,v1,v2);  %probability associated to the F-statistic.