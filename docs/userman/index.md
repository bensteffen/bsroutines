
## Read-in data ##

Read [here](./readin) how to read in data of different formats.

## Process subject data

Read [here](./functor) how to use a NirsDataFunctor to process data in the NirsSubjectData-structure.

## Optode and channel arrangments ##

Read [here](./coords) how do define or obtain probe and channel coordinates. These are used to assign brain regions to your probe positions and to create 3d-dimensional maps of your results.

## Data-inspection and -preparation ##

Read [here](./inspec) how to prepare your data for further analysis.





## Settings Structure ##

In this section I want to give some lines of code to get a proper settings structure for a NIRS-analysis script.

As explained in the [reference manual](../referenceman) every NirsObject has certain properties, which the user can view and set using the ''getProperty'' and ''setProperty'' method. Furthermore it is described how you can "bulk"-set properties by creating a structure and pass it to the ''setProperties'' method.

``` matlab
% connect the name of a experimental category with its numerical representation (= trigger_token) in the trigger vector
settings.experiment.category = {
    {'name','oneb','trigger_token',1}
    {'name','twob','trigger_token',2}
};
% a name starting with a digit (such as '2back') will work only untill you extract the results into a matlab-strcucure (using the results-methods), beause it woudn't be a valid strucuture field name

% define contrast vectors
settings.experiment.contrast = {
    {'name','oneb' ,'vector',[1 0]}
    {'name','twob' ,'vector',[0 1]}
    {'name','twob_vs_oneb' ,'vector',[-1 1]}
};
```

## Brain Mapping ##

Read [here](./mapping) how to create brain maps.


