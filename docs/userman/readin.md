We assume a folder containing NIRS (ETG-4000) and EEG data having the following file strucutre:

```
C:\Users\me\my-study\data:
 - Test017_Deoxy.csv
 - Test017_eeg.data
 - Test017_Oxy.csv
 - Test018_Deoxy.csv
 - Test018_eeg.data
 - Test018_Oxy.csv
 - Test019_Deoxy.csv
 - Test019_eeg.data
 - Test019_Oxy.csv
 - Test020_Deoxy.csv
 - Test020_eeg.data
 - Test020_Oxy.csv
```

The file names contain onformation about the subject IDs (preceeded by `Test`) and the measurement modality (`Oxy` and `Deoxy` for NIRS and `eeg` for EEG). 

## Read NIRS data

### ETG4000 CSV-files

The NIRS data was measurement using a Hitachi ETG-4000 system. To start a bulk-wise read-in try the following code:

``` matlab
  S = NirsSubjectData();  % create a NirsSubjectData-object named S
  S = S.setProperty('subject_keyword','Test');  % the digits in the file names after 'Test' will be used as subject IDs
  
  % specify the directory where the data is stored
  S = S.setProperty('read_directory','C:\Users\me\my-study\data');
  S = S.setProperty('read_type','etg4000');     % read type to read ETG-4000 data
  
  % read oxy-data
  S = S.setProperty('file_name_filter',{'','_Oxy','.csv'});  % use 'csv'-files with names ending with '_Oxy'
  S = S.readSubjectData('oxy.raw');                          % read the content and store the data with tag 'oxy.raw' in S
  
  % read deoxy-data
  S = S.setProperty('file_name_filter',{'','_Deoxy','.csv'});
  S = S.readSubjectData('deoxy.raw');
  
  % read trigger; because the file name filter was not modified, the trigger from the deoxy-files will be read
  S = S.setProperty('read_type','etg4000_trigger');
  S = S.readSubjectData('trigger.raw');
```
  
### ETG4000 TBL-database

You can also read data directly from a ETG4000 raw database (= TBL database, see [ETG-4000 raw data format](/tools/nirsexport)). This way, it is not nessesary to export CSV-files.

To read in a TBL-database create a `NAio.ETG4000Reader` object:

``` matlab
  S = NirsSubjectData();                        % create a NirsSubjectData-object named S
  
  r = NAio.ETG4000Reader('read_directory','C:\Users\me\my-study\data' ... % folder containing the ETG4000Export.TBL
                        ,'subject_keyword','S' ...
                        );
  % Pass the reader r to the readSubjectData-method as 2nd argument.
  S = S.readSubjectData('$x.raw',r);   
```
  
Use the `$x`-placeholder. By default `$x` will be replaced by `oxy`, `deoxy` and `trigger`, respectively.

Open a explore a TBL-database open a TBL-file with the [ETG-4000 raw data format](/tools/nirsexport) tool. There are different columns containing information about each measurement (TBL-ID, Name, Comment, Comment1, Comment2, Date, Duration). In the example above all measurements will be imported that contain the subject keyword in any of the columns. If you want to filter for a certain pattern in a certain column use the `source_selector` like `{<column_name1>,<filter_string1>,...}`. For instance:

``` matlab
  r = NAio.ETG4000Reader('read_directory','C:\Users\me\my-study\data' ...
                        ,'subject_keyword','S' ...
                        ,'source_selector',{'TBL-ID','(?!0083|0104)\d{4}','Comment','rst'} ... % exclude TBL-IDs 0083 and 0104 and select task "rst" using the Comment-column
                        );
  S = S.readSubjectData('rst.$x.raw',r);
```

If you created your own TBL-file ([HOWTO](/tools/nirsexport) ) you can specify this using the `tbl_file` property:

``` matlab
  r = NAio.ETG4000Reader('read_directory','C:\Users\me\my-study\data' ...
                        ,'tbl_file','rst.TBL' ...    % name of the TBL-file containing only task "rst"
                        ,'subject_keyword','S' ...
                        );
  S = S.readSubjectData('rst.$x.raw',r);
```

Use the `output_selector` property to select and rename the output. The default output selector is

``` matlab
  {'hb.oxy->oxy','hb.deoxy->deoxy','trigger'}
```

meaning that the read-in data structure has the field `trigger` as well as `hb` with two subfields `oxy` and `deoxy`. The specified fields will be put to the subject data base. Use the `->` Operator to rename the data. The ETG4000Reader has also the field `mes` (contains the raw data). If there were more than one probe set, the fields `oxy` and `deoxy` has the subfields `pr1'',`pr2'',... To rename theses to hemispheres try this code:

``` matlab
  % other settings for ETG4000Reader r ...
  r.setProperty('output_selector',{'hb.oxy->oxy','hb.deoxy->deoxy','pr1->left','pr2->right','trigger'});
  S = S.readSubjectData('$x.raw',r);
```
Calling tags method should show:

```
  S.tags(2) =

    'oxy.left.raw'
    'oxy.right.raw'
    'deoxy.left.raw'
    'deoxy.right.raw'
    'trigger'
```  

### NIRx

NIRx-data is organized in folders for each measurement day. Each of these day-folders contains a folder for each measurement. Each of these measurement-folders contains different files with information and the data itself. The file with inf-extension is used to identify each data set. You should open and explore a few of these to get an overview.

To read in a whole data set create a `NAio.NIRxReader` object. Set the `read_directory` property to the folder containing the day-folders. The `subject_keyword` property sepcifies the word the `Name`-field in the inf-file is scanned for to extract the subject ID (for instance the file entry `Name="VP6-RS1"` with `subject_keyword = 'VP'` will result in subject ID 6). For NIRx-data the `source_selector` has the shape `{<inf_entry1>,<filter1>,...}`, see examples below.

A topolayout-file (tpl-extension) must be provided for reading. It is needed to assign the channels properly. Use the `topolayout_path` property

``` matlab
S = NirsSubjectData();

r = NAio.NIRxReader(
    'read_directory','C:\Users\me\my-study\data' ...   % folder containing day-folders
    ,'subject_keyword','VP' ...
    ,'topolayout_path','C:\Users\me\my-study\data\viscortex.tpl' ... % path to tpl-file
    ,'source_selector',{'Study Type','checker'}           % use only data sets containg the word checker in the inf-entry 'Study Type'
);
         
S = S.readSubjectData('checker.$x.raw',r);
```
Output selection is very similar to `ETG4000Reader`. Differences are: there are not several probe sets for NIRx and the raw data is splitted into to parts (`mes.wl1` and `mes.wl2`, meaning wavelength 1 and 2).
  
  
  
## Read other data types ###

It is possible to read different file types. The EEG-data in the current example data set were exported in a binary format with single precission. Thus, to read the EEG-data run the following code:

``` matlab
  S = S.setProperty('read_type','binary.single');
  S = S.setProperty('file_name_filter',{'','eeg','.dat'});
  S = S.readSubjectData('eeg.raw');
```

## Check read-in

You might check which subjects where read:
```
  >> S.subjects() % returns a row-vector
  ans =
    17    18    19    20
  
  >> S.tags(1)    % using the tag-method of the superclass TagMatrix; returns a cell-array
  ans = 
    [17]
    [18]
    [19]
    [20]
```
Check data names:
```
  >> S.tags(2)
  ans = 
    'oxy.raw'
    'deoxy.raw'
    'trigger.raw'
    'eeg.raw'
```
## Read 2 NIRS probe sets

Assume we have ETG-4000 csv export with 2 probesets like:

```
C:\Users\me\my-other-study\data:
  - S01_Probe1_Deoxy.csv
  - S01_Probe1_Oxy.csv
  - S01_Probe2_Deoxy.csv
  - S01_Probe2_Oxy.csv
  ...
  - S10_Probe1_Deoxy.csv
  - S10_Probe1_Oxy.csv
  - S10_Probe2_Deoxy.csv
  - S10_Probe2_Oxy.csv
```

``` matlab
  Snoise = NirsSubjectData('read_directory','C:\Users\me\my-other-study\data','subject_keyword','VP');
  
  Snoise = Snoise.setProperty('read_type','etg4000');
  
  Snoise = Snoise.setProperty('file_name_filter',{'','_Probe1_Oxy','.csv'});
  Snoise = Snoise.readSubjectData('oxy.raw.p1');
  Snoise = Snoise.setProperty('file_name_filter',{'','_Probe2_Oxy','.csv'});
  Snoise = Snoise.readSubjectData('oxy.raw.p2');
  Snoise = Snoise.setProperty('file_name_filter',{'','_Probe1_Deoxy','.csv'});
  Snoise = Snoise.readSubjectData('deoxy.raw.p1');
  Snoise = Snoise.setProperty('file_name_filter',{'','_Probe2_Deoxy','.csv'});
  Snoise = Snoise.readSubjectData('deoxy.raw.p2');
  
  Snoise = Snoise.setProperty('read_type','etg4000_trigger');
  Snoise = Snoise.readSubjectData('trigger.raw');
```
Check result
```
  >> Snoise.subjects
  ans =
     1     2     3     4     5     6     7     8     9    10
  >> Snoise.tags(2)
  ans = 
    'oxy.raw.p1'
    'oxy.raw.p2'
    'deoxy.raw.p1'
    'deoxy.raw.p2'
    'trigger.raw'
```
