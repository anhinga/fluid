Note for Processing 3 users
===========================

Processing 3 requires to define `size()` inside the
function `setup()` with constant parameters.


The June 2015 experiments should run as is under Processing 3 
(tested for "jun_28_15_experiment"),
but May 2015 and August 2015 would need a patch.

The following minimal patch is tested using Processing 3.0.2
under Windows 7 for "aug_24_15_experiment" and
"may_9_15_experiment". 

For a more civilized way to patch this
see the corresponding section of
https://github.com/processing/processing/wiki/Changes-in-3.0

### aug_24:

this change in the `setup()` function in the main file of the sketch,
"aug_24_15_experiment.pde":

    //size(board_size*square_size, board_size*square_size);  
    size(640, 640);

### may_9:

comment out call to `size()` in the file "may_8_graph.pde":

    //size (third_size + slider_width + margin_size, third_size);

and instead insert `size()` with constant parameters into
the `setup()` function in the main file, "may_9_15_experiment.pde":

    void setup () {  
      current_run = new MasterConfig();  
      may_8_graph(current_run);  
      size(965, 915);  
    }

