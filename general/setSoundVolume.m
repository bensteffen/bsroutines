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


function volume = setSoundVolume(volume)
 
    % Loop over the system's mixers to find the speaker port
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
    % Packaged: 2017-04-27 17:58:17
   import javax.sound.sampled.*
   mixerInfos = AudioSystem.getMixerInfo;
   foundFlag = 0;
   for mixerIdx = 1 : length(mixerInfos)
      mixer = AudioSystem.getMixer(mixerInfos(mixerIdx));
      ports = getTargetLineInfo(mixer);
      for portIdx = 1 : length(ports)
         port = ports(portIdx);
         try
            portName = port.getName;  % better
         catch   %#ok
            portName = port.toString; % sub-optimal
         end
         if ~isempty(strfind(lower(char(portName)),'speaker'))
            foundFlag = 1;  break;
         end
      end
   end
   if ~foundFlag
      error('Speaker port not found');
   end
 
   % Get and open the speaker port's Line object
   line = AudioSystem.getLine(port);
   line.open();
 
   % Loop over the Line's controls to find the Volume control
   ctrls = line.getControls;
   foundFlag = 0;
   for ctrlIdx = 1 : length(ctrls)
      ctrl = ctrls(ctrlIdx);
      ctrlName = char(ctrls(ctrlIdx).getType);
      if ~isempty(strfind(lower(ctrlName),'volume'))
         foundFlag = 1;  break;
      end
   end
   if ~foundFlag
      error('Volume control not found');
   end
 
   % Get or set the volume value according to the user request
   oldValue = ctrl.getValue;
   if nargin
      ctrl.setValue(volume);
   end
   if nargout
      volume = oldValue;
   end