Evolutionary experiments with the architecture which we started to work with here in June 2018:

https://github.com/anhinga/fluid/tree/master/atparty-2018/game_of_afterlife
https://github.com/jsa-aerial/DMM/blob/master/design-notes/Early-2017/population-coordinate-descent.md
which picks a random matrix row, two weights within that row, and starts adjusting the matrix
by alpha*(w_ij - w_ik).
afterlife_conway_2_mutate_2 - by pressing 0 to 4 the user can select the best of 5 networks
currently working in parallel, and continue to work with that network and its 4 clones changed with Gaussian noise.

---

(this is just some instrumentation; more needs to be done before one can hope for CPPN-like results here.

this serves as an inspiration for us here: https://en.wikipedia.org/wiki/Compositional_pattern-producing_network

but this directory is just a beginning of an attempt to do something similar in the DMM context).

---

afterlife_balanced_coord_updates - initial instrumentation for "balanced coordinate updates",
a version of https://github.com/jsa-aerial/DMM/blob/master/design-notes/Early-2017/population-coordinate-descent.md
which picks a random matrix row, two weights within that row, and starts adjusting the matrix
by alpha*(w_ij - w_ik).
