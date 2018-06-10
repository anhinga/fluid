Code progression towards game_of_aterlife @party demo has been uploaded here, documentation is in progress...

The last of those demos contains audio and requires the install of Beads library for Processing 2.2.1: http://www.beadsproject.net/

---

The code evolved from https://github.com/anhinga/fluid/tree/master/Lightweight_Pure_DMMs (`aug_27_16_experiment`), described in https://arxiv.org/abs/1610.00831

That code is the first example of a self-modifying dataflow matrix machine (a more expressive version of neural network).

The engine in all these cases is a small handcrafted recurrent neural network processing streams of matrices instead of streams of numbers.

The master matrix containing the network weights is the top left rectangle.

The master row is the second row of the master matrix. The network weights in the master row are used to update the master matrix (including the master row itself).

---

In September 2016, 'nekel' changed initialization of the output layer to random and added normalization. This resulted in runs occasionally producing unexpected non-trivial dynamics. In June 2018, 'anhinga' instrumented random initialization using explicit randomly drawn seeds, so that the discovered non-trivial dynamics can be reproduced. The resulting code with one of the interesting seeds is `afterlife_9_1_seed`.

---

Then a `pseudoconway` activation function inspired by (but different from) the function describing one time step of Conway's game of life was added, and became one of the available activation functions for the neurons of our networks. The resuling code with one of the interesting seeds is `afterlife_conway_1_seed`.

---

Then the network size (and the size of the matrices it processes, for those are the same as the network size for pure lightweight dataflow matrix machines) was increased, resulting in `afterlife_conway_2_seed`. Then the graphical shape of the presentation was changed: squares representing cells were replaced by narrow vertically oriented rectangles, improving the vertical to horizontal ratio of the demo window and changing the aesthetic feeling from the demo (`afterlife_conway_3_seed`).

---

Then the first version of an orchestrated demo was created. To do that we broke the purity of the machine by programming substitutions of activation functions of the neurons at preselected moments of time, aiming for a more entertaining overall dynamics. This resulted in `afterlife_conway_4_seed`.

---

Then we added 40 Hz sound (the cognitive effects and physiological effects of sound in gamma frequency range are under very active investigation by the neuroscience community at the moment, with rather spectacular preliminary results being reported; which is why we added a warning at the beginning of the demo, as 40 Hz sound is obviously a pretty active agent and should be used with caution).

We added overtones decreasing the amplitude for each next overtone 1.4-fold: `currentGain /= 1.4;`

Then we use the master row of the network matrix to make the amplitude quiter, if the weights in the master row are positive (in this run we use the convention that dark, negative cells correspond to live cells in terms of Conway's game of life, and light, positive cells correspond to dead cells, so it is louder when the corresponding cell is darker). These are lines 364-367 in `afterlife_conway_5_seed_sound`:

`for( int i = 0; i < n_outputs; i++) {`  
       `float multiplier = 0.5 - 0.5 * outputs[0].matrix[1][i]; // we want to interpret -1 as 1, and 1 as 0`  
        `gainGlide[i].setValue(initGain[i] * multiplier);`  
`}`  
