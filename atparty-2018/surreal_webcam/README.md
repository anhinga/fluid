**Surreal webcam** is obtained by connecting a web camera to our earlier pipeline transforming image streams (`may_9_15_experiment` directory on the top level of this repository), enabling interesting interactive experiments.

The webcam handling and key press handling were added to `may_9_15_experiment` architecture in a rather ad hoc manner (and not in a principled manner suggested by `may_9_15_experiment` design, see https://arxiv.org/abs/1601.00713 for that design). The keys function as follows:

* `b` key toggles between black-and-white mode and color mode,
* `i` key toggles color inversion, 
* `f` key toggles attribution.

Otherwise, the standard ways to work with `may_9_15_experiment` software pipeline described elsewhere in this repository apply.

---

If you need to resize the software for a smaller screen, you might want to change the following two fragments in sync:

Line 3 and 4 of `may_8_graph.pde` to resize the window (you might want to maintain 4:3 ratio):

```processing
int hor_size = 640;  
int vert_size = 480;
```

for e.g.

```processing
int hor_size = 400;  
int vert_size = 300;
```

and then line 30 of `surreal_webcam.pde` to capture the whole camera input rather than its part in the smaller window:


```processing
input_rectangle.img.copy(cam, 0, 0, 640, 480, 0, 0, 640, 480);
```

for

```processing
input_rectangle.img.copy(cam, 0, 0, 640, 480, 0, 0, 400, 300);
```
