
An experiment in using data flow programs to create animations.
===============================================================

This experiment is done in Processing;
tested for Processing 2.2.1
under Windows 7 and Mac OS X 10.8.5.
Processing can be downloaded from
https://processing.org/

### -------------

For the "may_9_15_experiment"
the two example data flow graphs are contained in the source files
"may_8_graph.pde" and "may_9_graph.pde". By default the first graph is
used, it is a directed acyclic graph (does not contain loops). 
For a short video recording 30 seconds of interactively working
with this program see https://youtu.be/fEWcg_A5UZc

To switch to the other one (which does contain a loop)
change what is commented out in the source file "may_9_15_experiment.pde".

### -------------

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
which dynamically changes the program). Clicking and dragging
works the same as high-frequency multiple clicking 
(try it not only for linear
combinations, but also for waves).

### -------------

The "jun_28_15_experiment" is the first experiment where the
data flow program contains itself in one of its own nodes.
Currently this is only used to facilitate visualization
of the dynamically changing program. But this is a start
of true higher-order stream-based programming, as the
node containing a data flow graph can be linked to
other nodes of this graph in the future.

For a short video recording 30 seconds of interactively 
working with this program while it evolves (under
somewhat compressed timeline) see 
https://youtu.be/gL2L7otx-qc

### -------------

These are some of the experiments for the line of research described
in the following preprint on linear models of computation: 
http://www.cs.brandeis.edu/~bukatin/LinearModelsProgramLearning.pdf

The software architecture of May and June experiments is described in
this preprint: http://www.cs.brandeis.edu/~bukatin/HigherOrderDataFlow.pdf

Any questions or comments, feel free to e-mail to the first author
of these preprints.

### -------------

**August 5 - August 20 note:** It turns out that the architecture described
in our June experiments and July preprint can be modified to
eliminate even benign discontinuities resulting in
**continuous transformations** of software.

Moreover, this architecture allows to represent data flow graphs
of this class as **matrices of real numbers**.

We just posted a related software prototype, "aug_20_15_experiment", 
and expect to make
one or more videos and a preprint available today.

The preprint describing this new development is available at
http://www.cs.brandeis.edu/~bukatin/DataFlowGraphsAsMatrices.pdf

(This preprint might be lightly edited today.)

(The preprints linked from this page are currently at the bottom of
http://www.cs.brandeis.edu/~bukatin/partial_inconsistency.html )
