---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

# BSRoutines Docs

## Contact

If you have a question, contact me:

    me@ben-steffen.de

## Download/Clone ##

[GitHub-Repository](https://github.com/bensteffen/bsroutines)

## Install ##

### Notes ###

  * Do not use `initPackage`-file to install the routines. Use the newer `initroutines`, instead.
  * Do not add the paths manually by using the set-path-menu in the MATLAB-GUI. These changes would be applied to everyone using MATLAB on your computer.

### Step 1 ###

  * With access to our network-drive "S": Change your working MatLab directory to `S:\routines`
  * Without access to our network-drive "S": Download the {{usersection:psychphys:routines:initroutines.m |initroutines}} m-file and save it to a path known by MatLab. Set yout MatLab working directory to that path.

### Step 2 ###

Type into MatLab-console:

    initroutines('<path-of-routines>');
  
. For instance:

    initroutines('S:\routines\2016-10-27');
  
The needed paths are only set for the current MatLab-session. You can add the init-line to your startup m-file. This way, the routines will initilized on every MatLab start-up. Enter

    edit startup
  
to edit you startup file.


## Manual ##

[Reference manual](./referenceman)
<!-- [[:usersection:psychphys:routines:manual:referenceman|Reference manual]] -->

[User manual](./userman)
<!-- [[:usersection:psychphys:routines:manual:userman|User manual]] -->


## GUI-Tools ##

Following tools with graphical user interface (GUI) are available:
  * [ETG4000 export tool](/nirsexport)
  <!-- * [[usersection:psychphys:tools:nirsexport|ETG4000 export tool]] -->
  * [NIRS-Planer](/nirsplaner)
  <!-- * [[usersection:psychphys:channelxyz:nirsplaner|NIRS-Planer]] -->
