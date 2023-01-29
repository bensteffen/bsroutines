## Visual time-series inspection

Define the time-series you want to inspect as well as a `NirsPlotTool`-instance, for example:
``` matlab
settings.experiment.time_series = {...
    {'name','oxy.raw'  ,'sample_rate',10,'trigger_name','trigger'}
    {'name','deoxy.raw','sample_rate',10,'trigger_name','trigger'}
    {'name','cbsi.raw' ,'sample_rate',10,'trigger_name','trigger'}
    {'name','oxy.bpf'  ,'sample_rate',10,'trigger_name','trigger'}
    {'name','deoxy.bpf','sample_rate',10,'trigger_name','trigger'}
    {'name','cbsi.bpf' ,'sample_rate',10,'trigger_name','trigger'}
};
P = NirsPlotTool(settings);
```
Use the `plotChannels`-method to display the bandpass-filtered oxy-Hb and deoxy-Hb time-series stored in a `NirsSubjectData`-object `S` for a specified subject:
``` matlab
subject_id = 11;
roi = 1:22; %  = all channels
P = P.plotChannels(S,subject_id,roi,{'oxy.bpf','deoxy.bpf'},{'r','b'},{'-','-'});
```

`{'r','b'}` defines the color (red and blue) for each time series. `{'-','-'}` defines the line style (contineous) for each time series.

**Note** this little bug: You have to resize the appearing window to make the plot become visible.

Use the `showTrigger`-method to mark the experimental events in the plot:
``` matlab
subject_id = 11;
P = P.plotChannels(S,subject_id,1:22,{'oxy.bpf','deoxy.bpf','cbsi.bpf'},{'r','b','m'},{'-','-','--'});
P.showTrigger(S,subject_id,'oxy.bpf',2);
```
The last lines displays the trigger for the oxy-Hb time-series with a displayed block duration of 2 seconds in this case. (**Note** that this displayed block duration doesn't have any effect on further analysis)

Use the left mouse button to identify channels and events. Multiple selection using the ctrl or alt key is enabled.

## Exclude events

The easiest way to exclude events from further analyses is to set the respective trigger-entry to 0. For example you can use a `NirsDataFunctor`. To avoid a re-readin caused by wrong exclusions, we duplicate the original trigger before the actual exclusion:
``` matlab
S = S.processData(NirsDataFunctor('function_handle',@(X) X,'input_names',{'trigger.raw'},'output_names',{'trigger'})); % duplicate

F = NirsDataFunctor('input_names',{'trigger'});
% Template: S = S.processData(NirsDataFunctor('function_handle',@(X) setvalue(X,valueat(find(X),[events]),0)),subject_id); 
S = S.processData(NirsDataFunctor('function_handle',@(X) setvalue(X,valueat(find(X),[2 5 10:15]),0)),11); % exclude events 2,5 and 10 to 15 for subject 11
```
It is easier to use the `NAev.excludeEvents`-function:
``` matlab
F = NirsDataFunctor('input_names',{'trigger'});
% Template: S = S.processData(F.setProperty('function_handle',@(X) NAev.excludeEvents(X,[events])),subject_id);
S = S.processData(F.setProperty('function_handle',@(X) NAev.excludeEvents(X,[2 5 10:15])),11); % exclude events 2,5 and 10 to 15 for subject 11
```

## Interpolate noisy channels using their neighbours

There are three ways to replace noisy chanels be the average of surrounding channels.

### Manually define replacing channels

Use function `NAfilt.interpolateChannel`.
``` matlab
F = NirsDataFunctor('input_names',{'oxy.raw','deoxy.raw'}); % all interpolation will be done for oxy- and deoxy-Hb raw

% interpolate CH49 using CH[48 38 28 39] and CH50 using CH[39 29 40 51] for subject 3
S = S.processData(F.setProperty('function_handle',@(X) NAfilt.interpolateChannel(X,[49 50],{[48 38 28 39],[39 29 40 51]})),3);
% interpolate CH50 using CH[48 39 29 40 51] for subject 6
S = S.processData(F.setProperty('function_handle',@(X) NAfilt.interpolateChannel(X,50,{[48 39 29 40 51]})),6);
```
### Automatic selection of surrounding channels

Replacing channels are selected by gaussian weighting.

  * Use `gaussianNeighborInterp` when you have read in a coordinate text-file for your probe set `PS`. For example:
    ``` matlab
    F = NirsDataFunctor('input_names',{'oxy.raw','deoxy.raw'}); % all interpolation will be done for oxy- and deoxy-Hb raw

    % interpolate CH49 and CH50 for subject 3
    S = S.processData(F.setProperty('function_handle',@(X) NAfilt.gaussianNeighborInterp(X,NAps.probesetxyz(PS),[49 50])),3);
    % interpolate CH50 for subject 6
    S = S.processData(F.setProperty('function_handle',@(X) NAfilt.gaussianNeighborInterp(X,NAps.probesetxyz(PS),50)),6);
    ```
  * Use `gaussianNirsInterp` when you have defined the recangular dimension for your probe set `PS` using the `dimension` property. For example:
    ``` matlab
    F = NirsDataFunctor('input_names',{'oxy.raw','deoxy.raw'}); % all interpolation will be done for oxy- and deoxy-Hb raw
  
    % interpolate CH49 and CH50 for subject 3, 30 is the optode distance in millimeters
    S = S.processData(F.setProperty('function_handle',@(X) NAfilt.gaussianNirsInterp(X,PS.channelMatrix(),[49 50],30)),3);
    % interpolate CH50 for subject 6, use default value 30 mm for the optode distance by omitting the 4th argument
    S = S.processData(F.setProperty('function_handle',@(X) NAfilt.gaussianNirsInterp(X,PS.channelMatrix(),50,30)),6);
    ```
  
  
### Automatically interpolate bad channels

The function `NAfilt.channelInterpolation` enables you to automatically interpolate bad channels (which are zero line channels and channels containing NaNs):
``` matlab
% define subject-channel pairs (using a nx2 cell array) for channels you want to interpolate after visual inspection:
ch2ip = {
    3 ,[1 2 22] % subject 3, CHs[1 2 22]
    20,[4 5]    % subject 20, CHs[4 5]
};

% perform bad channel interpolation for subjects without manually specificied bad channels:
S = S.processData(NirsDataFunctor('function_handle',@(X,Y) NAfilt.channelInterpolation(X,PS),'input_names',{'oxy.raw','deoxy.raw'}),exclude(S.subjects,cell2mat(ch2ip(:,1))));

% perform interpolation for subjects with manually specificied bad channels:
for i = 1:size(ch2ip)
    [sid,chs] = deal(ch2ip{i,:});
    S = S.processData(NirsDataFunctor('function_handle',@(X,Y) NAfilt.channelInterpolation(X,PS,chs),'input_names',{'oxy.raw','deoxy.raw'}),sid);
end
```