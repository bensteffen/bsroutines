function t = getBrainTangentials(p)

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
    % Date: 2016-03-23 11:03:07
    % Packaged: 2017-04-27 17:57:55
[a,b,c] = deal(95,78,79);

p = p./[a b c];

t = sphtangentials(p(1),p(2),p(3));
t = t.*repmat([a b c]',[1 3]);
t(:,1) = t(:,1)/norm(t(:,1));
t(:,2) = t(:,2)/norm(t(:,2));
t(:,3) = t(:,3)/norm(t(:,3));

t = [-t(:,3) t(:,2) t(:,1)];