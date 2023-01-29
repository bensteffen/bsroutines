# NirsObject

Each class, which is derived from NirsObject, has "properties". Each property has a name and a value. When a `NirsObject` is created each property value is set to the default values. The `NAnaT_DEFAULTS.m` file default values. For example we create a `NirsEventRelatedAverage` object and check the default value for the *"interval"* property using the `getProperty` method:
``` matlab
ERA = NirsEventRelatedAverage();
ERA.getProperty('interval')

ans = 
  0    30
```
You can set an other value for a property using the `setProperty` method. This method can also handle multiple name-value pairs:
``` matlab
ERA.setProperty('interval',[0 20]);                     % single name-value pairs
ERA.getProperty('interval')
ans = 
  0    20

ERA.setProperty('average_window',[0 20],'pre_time',1);  % multiple name-value pairs
ERA.getProperty('average_window')
ans = 
  0    20

ERA.getProperty('pre_time')
ans = 
  1
```
Properties values can also be set using a structure with the object-keyword and the property names as field names. You can get the object-keyword from the `NAnaT_DEFAULTS`.m-file. The settings structure is then passed to the `setProperties` method. For example:
``` matlab
settings.event_related_average.interval = [0 20];
settings.event_related_average.average_window = [0 20];
settings.event_related_average.peak_window = [5 15];
settings.event_related_average.pre_time = 1;

ERA = NirsEventRelatedAverage();
ERA = ERA.setProperties(settings);
```

# NirsProbeset

**Superclasses:** NirsObject

Hold and analyzes the spatial positions of measurement probes and channels

## Properties

| Name | Type/Constrains | Default | Description |
|---|---|---|---|
| `dimension` | Numeric vector with 2 elements > 0 | `[]` | In the case of a classic rectangular optode arrangement you can specify the number or optodes per row (`m`) and per column (`n`) as a vector `[m n]` |
| `optode_distance` | Positive scalar | `30` | Holds the typical optode distance (in millileters) of the probe set |
| `transformation` | Cell string | `{}` | Cell of strings specifying transformations which are applied to the 2d-coordinates of the probe set. Following transformations are implemented: `flip_up2down`, `flip_left2right`, `transpose`, `rotate90`. The transformations are applied in the order from left to right |
| `brain_coord_file` | Path | `''` | Give the path to a text file containing the 3d (xyz) coordinates of the optodes and/or channels. Read [here](../userman/coords.md) how such a file must be formed. |
| `xy_coord_file` | Path | `''` | Give the path to a text file containing the 2d (xy) coordinates of the optodes and/or channels. Read [here](../userman/coords.md) how such a file must be formed. |
| `optode_channel_assignment` | `'on'` \| `'off'` | `'off'` | If your coordinate files only contain the optode coordinates, turn this option 'on'. In this case, the channel coordinates will be calculated from the optode coordinates. |
| `anatomic_assignment_type` | `'aal'` \| `'brodmann'` | `'brodmann'` | Defines which brain parcellation is used to assign channels to functional or anatomic brain regions. When a 3d coordinate file was successfully scanned, you can view a table of the assignments by evoking the `showAnatomicLabels()` method of a NirsProbeset object. |
| `template_name` | Valid template name: `'Colin27(541mm)'`, `'Colin27(570mm)'`, `'Colin27(610mm)'`, `'Colin27'`, `'age8'` | `'Colin27'` | If the template is not specified in the coordinate file it can be set here. |


# NirsSubjectData ###

**Superclasses:** TagMatrix, NirsObject

Stores data per subject. A unique numeric ID is assigned to each subject. Data will be stored using a data name and the subject ID. NirsSubjectData objects are able to read automaticly subject-wise data from a given directory.

### Example:

Assume we have files containing NIRS-data from an ETG-4000 system
in the directory "C:\nirsdata" with names
```
VP05_Oxy.csv
VP05_Deoxy.csv
VP07_Oxy.csv
VP07_Deoxy.csv
```

To automatically the data use following code:
``` matlab
S = NirsSubjectData();
S = S.setProperty('read_directory','C:\nirsdata','subject_keyword','VP');

% read oxy-Hb data
S = S.setProperty('read_type','etg4000');
S = S.setProperty('file_name_filter',{'','_Oxy','.csv'});
S = S.readSubjectData('oxy');
% read trigger
S = S.setProperty('read_type','etg4000_trigger');
% note: the file name filter is not chagned, thus, the trigger 
% will be read from the oxy-files in this case.
S = S.readSubjectData('trigger');
```
To plot the trigger for subject 1 stored in subject data S
and count the events of condition 2:
``` matlab
tr = S.getSubjectData(1,'trigger');
figure; plot(tr);
number_cond2 = length(find(tr == 2))
```

## Methods

### getSubjectData

Retrieve data from the data base.

#### Usage:
``` matlab
% The data for subject ID sid and the data with name dname will be assigned to x
x = S.getSubjectData(sid,dname)
```

### readSubjectData

Subject-assignment is done by scanning  each file name for a user-definable subject-keyword.

## Properties

| Name | Type/Constrains | Default | Description |
|---|---|---|---|
| `read_directory` | Path | `''` | Directory where data is read from using the method `readSubjectData`. |
| `file_name_filter` | Cell string: `{<prefix> <postfix> <extension>}` | `{'' '' ''}` | Three-element cell-array of strings specifying the filter, which is used to filter the file names in the read directory. The first element gives the file name start. The second the file name end. The third the file extension, e.g. '.csv'. Empty strings mean that no filter is used. |
| `subject_keyword` | String | `S` | The subject ID for the respective file name will be searched directly behind the subject keyword. For instance, for a file name `'nirsdata_SUBJ_08_Oxy.csv'` a keyword `'SUBJ_'` will results in a subject ID 8. |
| `read_type` | String | `'etg4000'` | A string specifying how the found files will be handled and read. Use `'etg4000'` for NIRS-data from the ETG-4000 system. Use `'etg4000_trigger'` to the respective trigger. Use `'txt'` to read plain text. Use `'binary'` to read binary files. You can add the data type of the binary file by adding it with a dot, for instance `'binary.int32'`. |
| ` ` | | ` ` | |


# NirsPlotTool ###

**Superclasses:** NirsObject


This class is used to create plot and map data.

### Example:

Maps values given by the `'values2map'` property of the 
NirsPlotTool object `P`.
``` matlab
P.map('values');
```
Maps statsitic values stored in a NirsStatistics object T under
the names given by the `'tests2map'` property of the NirsPlotTool
object P.
``` matlab
P = P.map('statistics',T);
```
Check for further information the [brain mapping tutorial](../userman/mapping.md).


## Methods #### 

### `map`

Creates figures of spatial maps. Check the plot-tool property table in the NirsPlotTool manual for possible settings.

## Properties

| Name | Type/Constrains | Default | Description |
|---|---|---|---|
| `standard_score` | `'on'` \| `'off'` | `'off'` | Transform values to standard score before mapping. |
| `statistic_map_values` | `'test_statistic'` \| `'p-values'` \| `'effect_size'` | `test_statistic` | Defines which values are used for statistic mapping; i.e. t-values or correlation coefficients for `'test_statistic'`, Cohen's d for `'effect_size'`. |
| `era_plot_style` | `'scroll'` \| `'probeset'` | `'probeset'` | Defines the plot style when using the plotEra-method. The `'scroll'` option is obsolete. The `'probeset'` option produces a plot, in which the ERA-plots for all channels are arranged according to the given probe set arrangement. |
| `global_scale` | Vector with 2 ascending elements | `[]` | Defines a y-scale that is used for all plots of a figure. When this option is the empty array (i.e. []) each plots select its own scale. |
| `era_mark` | Vector with 2 ascending elements | `[]` | Defines a range in seconds, which will be marked in ERA-plots. Give a n times 2 array to mark multiple ranges. |
| `show_peaks` | `'on'` \| `'off'` | `'on'` | |
| `show_probeset` | `'on'` \| `'off'` | `'on'` | When turned to `'on'` channel IDs are shown in mapping figures. |
| `show_head` | `'on'` \| `'off'` | `'off'` | When turned to `'on'` a transparent head will be shown in mapping figures. |
| `color_map` | Name of a color map | `'braincmap2'` | Name of a color map used for brain mapping. A color map must be a function, which takes the number of value bins for color scaling. For example MatLab-builin color maps: jet, autumn, etc. . There are also special brain-mapping color maps: braincmap, braincmap2 (the center color is brain-gray) and gap (see color_gap property) |
| `color_limit` | Vector with 2 ascending elements | `[]` | Defines the color limit for brain maps. |
| `color_gap` | | `'significant'` \| `[]` \| Vector with 2 ascending elements | This property only has an effect, when the color map 'gap' is chosen. It defines a range within values are colored in brain-gray and are not visible this way. |
| `map_type` | `'map'` \| `'brain_map'` \| `'brain_blobs'` \| `'head_map'` | `map` | Specifies the map type for brain mapping. `'map'`: 2d map. `'brain_map'`: 3d map on the brain surface, interpolation on. `'brain_blobs'`: 3d on the brain, no interpolation. `'head_map'`: 3d on the head surface, interpolation on. |
| `values2map` | Cell of numeric vectors \| cell of cells | `{}` | Cell array holding the values for brain mapping. The dimension of the cell array determines the dimension of the mapping plot. For each (cell-type) element of the input a own brain plot will be generated (matrix-style figure), whereas the content the element will be used for the respective brain map. For instance `{ {values11_left,values_11_right},{values12_left,values_12_right} }` will generate two brain maps in a 1x2 arrangement with two value arrays (left and right) for each brain. To create the plot use the method map: map('values') |
| `tests2map` | String cell \| cell of cell strings | `{}` | Same as `values2map`, expect that instead of specifying numeric arrays, the names of the statistic analysis are given, which are stored in a `NirsStatistic`-object. To create the plot use the method map: `map('statistics',T)`, whereas `T` is a `NirsStatistic`-object. |
| `probesets2map` | String \| cell string \| cell of cell strings | `{}` | String-input: Name of the probeset, which will be used for all brains. Cell-input: Probeset for the respective value array or test-name, for the example above `{ {'left','right'},{'left','right'} }`. |
| `row_names` | Cell string \| cell of string cells | `{}` | String-cell or cell of string-cells (for multiple lines) holding the row names of a matrix-style mapping figure |
| `column_names` | Cell string \| cell of string cells | `{}` | String-cell or cell of string-cells (for multiple lines) holding the column names of a matrix-style mapping figure |
| `view_angles` | Vector with 2 elements | `[90 90]` | Two-element input defining the view-angles (see MatLab-builtin view function) of each plot. Analogue usage as `'probesets2map'`. |
| `plot_parent` | `[]` \| handle  | `[]` | Specifies the handle of the figure that will contain the plot. when this property is set to [] a new figure will be created for each plot. |
| `probesets` | `'name'` | `''` | List of probesets-objects (see NirsProbeset) used for plotting and mapping each tagged with `'name'`. |
| | `'probeset'` | NirsProbeset | 



### NirsEventRelatedAverage

**Superclasses:** NirsAnalysisObject, TagMatrix, NirsObject


Object used to calculate event related averages for time series with a trigger.

### Example:

To conduct a event-related averaging:
``` matlab
ERA = NirsEventRelatedAverage();     % create average object
ERA = ERA.setProperties(settings);   % apply predefined settings (stored in structure "settings")
ERA = ERA.createEra(S);              % perfom averaging using the subject data stored
                                     % stored in the NirsSubjectData S
```

## Methods

### createEra

Start averaging process. Event related averages, peaks, and averaged amplitudes will be calculated.
``` matlab
% calculates the  for NirsSubjectData S. Results are stored in ERA.
ERA = ERA.createEra(S)
```



#### Properties

| Name | Type/Constrains | Default | Description |
|---|---|---|---|
| `interval` | Vector with 2 ascending elements | `[0 30]` |  Time window (in seconds), which is used to calculate an average response per subject, channel and condition. The average amplitude (amplitudes) and the peaks (maxima and minima are extracted from this average response.) |
| `peak_window` | Vector with 2 ascending elements \| cell of such vectors | `[0 30]` | Defines the window within that a peak detection will be conducted. The results will be stored with the tags `'maxima.value'`, `'maxima.latency'`, `'minima.value'`, `'minima.latency'`. If you pass the empty array `[]`, no peak detection will be conducted. If you pass a cell array of time ranges, averaging will be conducted for each of these ranges. The tags will be extended by `'.win1'`, `'.win2'`, ... |
| `average_window` | Vector with 2 ascending elements \| cell of such vectors | `[0 30]` | The amplitudes of the averaged response (see interval) will be averaged within this time window (in seconds). The results will be stored with the tags `'amplitudes'`. If you pass the empty array `[]`, no amplitude averaging will be conducted. If you pass a cell array of time ranges, averaging will be conducted for each of these ranges. The results will be stored with the tags `'amplitudes.win1'`, `'amplitudes.win2'`, ... |
| `pre_time` | Scalar > 0 | `2` | This time (in seconds) defines the length before the event onset that is used for baseline correction. |
| `peak_detection_sensitivity` | Scalar > 0 | `0.001` | Defines the sensitivity for peak detection (see peakdet). Signal changes below this threshold will not be detected as peaks. |
| `linear_detrend` | `'on'` \| `'off'` | `'off'` | When this flag is turned to `'on'` the averaged responses will be detrended linearly using the MATLAB-built function `detrend` |


### NirsRegression ###

**Superclasses:** NirsAnalysisObject, TagMatrix, NirsObject


Performing a regression based on a general linear model (GLM). In the default case a hemodynamic response function is modelled for each condition. The conditions and their onsets are defined by the trigger attached to a time series.

### Example:

You may have created a settings strucute defining the time series and
conditions. Then perform the regression:
``` matlab
R = NirsRegression();            % create regression object
R = R.setProperties(settings);   % apply predefined settings (stored in structure "settings")
R = R.regress(S);                % perfom regression using the subject data stored
                                 % stored in S
```

You can check the GLM by having a look on the design matrix. Use the    
`getDesginMatrix` method for this prupose. You may also have a
`NirsSubjectData`-object with name `S` in your workspace. Also you have
defined time series with a trigger with name `'trigger'` assigned to those.
``` matlab
S = R.getDesignMatrix(S,'.designmx');
designmx = S.getSubjectData(7,'trigger.designmx');  % get design matrix for subject 7
figure; plot(designmx);
% or
figure; imagesc(designmx); colormap gray;
```

## Methods

### `getDesignMatrix`

Calculates the design matrix.

#### Usage:
``` matlab
% calculates the design matrix for the current current settigngs and for each subject in NirsSubjectData S. The design matrices will be stored adds with the tags '<trigger_name>.<postfix>' in the output S
S = R.getDesignMatrix(S,postfix)
```

### `regress`

Performs a linear regression. Results are stored with the tags "betas" (beta-values) and "R2" (explained variance).

#### Usage:
``` matlab
% performs regression on NirsSubjectData S
R = R.regress(S) 
% The result tags will be perceeded by the string 'reg_name.'.  This way different regression analysis can be stored simultaneously in one regression object.
R = R.regress(S,reg_name) 
```

## Properties

| Name | Type/Constrains | Default | Description |
|---|---|---|---|
| `event_duration` | Scalar >= 0 | `0` | Specifies the width the boxcar for every trigger, which is convolved with the HRF. Use a duration of 0 for event-related design. In this case, the width of the boxcar will be one sampling point. |
| `standardize_hrf` | `'on'` \| `'off'` | `'off'` | Each model function will be divided by its standard deviation after convolution, when this option is set to `'on'`. Use `'on'` for example, when different condition have different event duration to make betas for these conditions comparable between each other. |
| `global_regressors` | Cell string \| vector \| `{}` | `{}` | String list of data entries in the subject data object, which will be added to the design matrix. This data must be a vector with same length as the design matrix. For example it could be the name of a heart rate measurement. |
| `channel_wise_regressors` | Cell string \| vector \| `{}` | `{}` | String list of data entries in the subject data object, which will be added to the design matrix. This data must have the same size as the analyzed data. Each channel from the channel-wise regressor will be added channel-wise to the design-matrix. |
| `event_related_hrfamps` | String | `''` | This property defines a name of an entry in the subject data object for each subject, which holds a vector with individual amplitudes for each trial. The trigger value for each trial will be set to the respective amplitude (normally every amplitude is 1). This trigger is then convoluted with the HRF. This option can be used for example to perform an EEG-informed regression. |
| `event_related_regressors` | `'name'`          | String | You can add an additional (to the HRF) model function to the design matrix. For example a negative gaussian to model the initial dip. |
|                            | `'handle'`        | Call/vector of function handles \| `{}` | |
|                            | `'duration'`      | Scalar >= 0 | |
|                            | `'trigger_token'` | Numeric vector | |
