## ETG-4000 probesets, without 3D coordinates

This section is for those, who use a ETG-4000 optode arrangement and 2d-mapping and/or mapping of hemodynmic responses with the probeset-style.

For a 3 by 11 optode arragnment use:
``` matlab
PS = NirsProbeset('dimension',[11 3]);
PS.channelMatrix()   % view channel-matrix
```
Use the `transformation`-property to arrange the channels according to your setup, typically like:
``` matlab
PS = NirsProbeset('dimension',[11 3],'transformation',{'transpose'});
PS.channelMatrix()
```
For a 3 by 5 optode arragnment, which has typically a left and a right probeset use:
``` matlab
PS1 = NirsProbeset('dimension',[5 3]); % (typically left)
PS1.channelMatrix() % view channel-matrix
PS2 = NirsProbeset('dimension',[5 3]); % (typically right)
PS2.channelMatrix() % view channel-matrix
```
use the "transformation"-property to arrange the channels according to your setup:
```matlab
% for view from the top
PS1 = NirsProbeset('dimension',[5 3],'transformation',{'flip_up2down'});
PS1.channelMatrix()
PS2 = NirsProbeset('dimension',[5 3],'transformation',{'flip_left2right'});
PS2.channelMatrix()

% for view from the sides
PS1 = NirsProbeset('dimension',[5 3],'transformation',{'flip_up2down','rotate90'});
PS1.channelMatrix()
PS2 = NirsProbeset('dimension',[5 3],'transformation',{'flip_up2down','rotate90'});
PS2.channelMatrix()
``` 
 
## 3D coordinates

Basically, there are 3 cases.

**Case 1:** You have the xyz-coordinates of the channels then use then create a text-file that looks like this ({{:usersection:psychphys:channelxyz:3x5:3x5_left_ch02ont3.txt|download}})
``` matlab
CH1	-89.00	-44.00	-2.00
CH2	-88.00	-15.00	-4.00
CH3	-86.00	15.00	-6.00
... 
CH20    -80.00	-9.00	53.00
CH21    -74.00	17.00	50.00
CH22	-66.00	37.00	45.00
```
Very good, you already have the MNI-coordinates for each channel. To read in these, use:
``` matlab
PS1 = NirsProbeset('brain_coord_file','3x5_left_CH02onT3.txt');
```  
The probabilistic anatomic assignment will be calculated and 

Note: the coordinate file has to be in your current folder or a folder known by MatLab. Otherwise, give the absolute path to the file.

You may check the arrangment using the `showBrodmann`-function:
``` matlab
showBrodmann([22 44 45],'probeset',PS1,'view_angles',[-90 15]);
```
**Case 2:** You have the xyz-coordinates of each optode. Then create a text-file that looks like this ({{:usersection:psychphys:channelxyz:3x11:frontal52.txt|download}})
```
OP1	-73.3694	-36.2703	-23.9820
OP2	-76.3448	-41.5517	12.5517
OP3	-74.1458	-47.0417	44.9375
...
OP33	74.4602	-42.0177	55.43361


CH1	30	33
CH2	27	30
...
CH52	4	1
```
First, the XYZ-coordinates for each optode are listed. The second list defines the optode pair for each channel. For instance channel 1 lies between optode 30 and optode 33. For this kind of file, the ''optode_channel_assignment'' property of the NirsProbeset-object must be switched to ''on'' before the coordinate file path is specified:
``` matlab
PS = NirsProbeset('optode_channel_assignment','on','brain_coord_file','frontal52.txt');
```
You may check the result by calculating (and illustrating) the coverage of the dorso-lateral pre-frontal cortex (dlPFC, Brodmann Area 9 and 46):
``` matlab
dlpfc_coverage = coversBrodmann([9 46],PS,'show',true) 
% dlpfc_coverage: vector containing the probability to cover BA 9 or 46 for each channel
```
**Case 3:** There are also pre-calculated anatomic assigments from the {{http://www.jichi.ac.jp/brainlab/index_de.html|"Brainlab"}}. These are xls-files containing the XYZ-coordinates of all optodes and channels and the probabilistic assignment to a brain region in an other column. You can find a collection of these files in the Media Manager (channelxyz->brainlab->) or in ''S:\AG-Materialien\NIRS-Probesetkoordinaten'' (NOTE: the channnel-optode assignment differs from ours. You can make a copy of the optode file you need and change the channels number to fit your channel arrangment). Use for instance:
``` matlab
PS1 = NirsProbeset('anatomic_assignment_type','aal' ...
    ,'anatomic_assignment_column',6 ...
    ,'brain_coord_file','C1_Mid3_Cor_3x5.xls' ...
);
```      
## Assignment Algorithm ===

You can find the assignment algorithm in the ''anatomicalAssignment.m''-file. It is based on the {{http://www.jichi.ac.jp/brainlab/tools.html|''nfri mni estimation''}}.
