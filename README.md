
An experiment in using data flow programs to create animations.
===============================================================

This experiment is done in Processing;
tested for Processing 2.2.1
under Windows 7 and Mac OS X 10.8.5.
Processing can be downloaded from
https://processing.org/

For the "may_9_15_experiment"
the two example data flow graphs are contained in the source files
"may_8_graph.pde" and "may_9_graph.pde". By default the first graph is
used, it is a directed acyclic graph (does not contain loops). 

To switch to the other one (which does contain a loop)
change what is commented out in the source file "may_9_15_experiment.pde".

The "jun_21_15_experiment" is the first experiment with
dynamic data flow graph, a stream of data flow graphs
which are evolving using **almost continuous transformations**
and the program is executed while it changes on the fly in this almost
continuous fashion.

Clicking on the wavemaking nodes restarts a wave at the point of
click. The coefficients in the linear combinations are changed
by clicking on the
the controllers on the right of the images generated
as lienar combination for may_9 experiment,
and for jun_21 experiment those coefficients are controlled
by clicking on those images themselves (and by the script
which dynamically changes the programi). Clicking and dragging
works the same as high-frequency multiple clicking 
(try it not only for linear
combinations, but also for waves).

These are some of the experiments for the line of research described
in the following preprint on linear models of computation: 
http://www.cs.brandeis.edu/~bukatin/LinearModelsProgramLearning.pdf
(currently this is the last link at 
http://www.cs.brandeis.edu/~bukatin/partial_inconsistency.html )


The text describing the technicalities of those experiments is
expected no later than mid-July.

Any questions or comments, feel free to e-mail to the first author
of that preprint.
