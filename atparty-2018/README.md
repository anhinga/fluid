Materials of my June 9, 2018 compo entries for @party, http://atparty-demoscene.net/. This material has been posted on June 10 in order to comply with the @party compo rules.

The software is written in Processing 2.2.1, tested under Windows 10.

* game of afterlife

* surreal webcam

We try to document how to use these software artifacts, their architecture, and history of their creation.

**Game of Afterlife** is a self-referential self-modifying generalized neural network which processes streams of matrixes (we call those networks "pure lightweight dataflow matrix machines"), with added activation function inspired by Conway's game of life, with random initialization of the initial state (a random seed we liked was cached for reproducibility), and with some ad-hoc hacks, which modify the network at the selected points of time and add sonification based on 40Hz motives with overtones. We have released the silent version, and the code progression for this software as well.

Performance recording: https://scenesat.com/videoarchive/66 starting at 13:03:10 (13 hours 3 min 10 sec, in case the URL changes, that is "2018-06-09 @-party 2018 - Day 2 (13.75 hours)").

**Surreal webcam** is obtained by connecting a web camera to our earlier pipeline transforming image streams ("may_9_15_experiment" directory on the top level of this repository), enabling interesting interactive performances, so this was entered as a freestyle interactive compo.

Performance recording: https://scenesat.com/videoarchive/66 starting at 12:40:25.

The webcam handling and key press handling were added to `may_9_15_experiment` architecture in a rather ad hoc manner (and not in a principled manner suggested by "may_9_15_experiment" design, see https://arxiv.org/abs/1601.00713 for that design). The keys function as follows:

* `b` key toggles between black-and-white mode and color mode,
* `i` key toggles color inversion, 
* `f` key toggles attribution.

Otherwise, the standard ways to work with `may_9_15_experiment` software pipeline described elsewhere in this repository apply.
