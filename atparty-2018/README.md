Materials of my June 9, 2018 compo entries for @party will be added on June 10 (surreal_webcam is now committed, game_of_afterlife to follow).

The software is written in Processing 2.2.1, tested under Windows 10.

* game of afterlife

* surreal webcam

There will be documentation on how to use them, their architecture, and history of their creation.

**Game of Afterlife** is a self-referential self-modifying generalized neural network which processes streams of matrixes (we call those networks "pure lightweight dataflow matrix machines"), with added activation function inspired by Conway's game of life, with random initialization of the initial state (a random seed we liked was cached for reproducibility), and with some ad-hoc hacks, which modify the network at the selected points of time and add sonification based on 40Hz motives with overtones. We are going to release the silent version as well.

**Surreal webcam** is obtained by connecting a web camera to our earlier pipeline transforming image streams ("may_9_15_experiment" directory on the top level of this repository), enabling interesting interactive performances, so this was entered as a freestyle interactive compo.

The webcam handling and key press handling were added to "may_9_15_experiment" architecture in a rather ad hoc manner (and not in a principled manner suggested by "may_9_15_experiment" design, see https://arxiv.org/abs/1601.00713 for that design). The keys function as follows:

* `b` key toggles between black-and-white mode and color mode,
* `i` key toggles color inversion, 
* `f` key toggles attribution.

The release is delayed till June 10 in order to comply with the @party compo rules.
