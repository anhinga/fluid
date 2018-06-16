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

---

One can also transform movies through this pipeline. To do so, the following changes are required in the main file of the sketch (in this case, `surreal_webcam.pde`).

Line 4: instead of

```processing
Capture cam;
```

use

```processing
Movie mov;
```

Lines 18-19: instead of webcam initialization

```processing
  cam = new Capture(this, 640, 480, 30);
  cam.start();
```

use movie initialization (in this example, the movie file name is `MVI_9270.MOV`; the movie file must be in the `data` folder of your Processing sketch):

```processing
  mov = new Movie(this, "MVI_9270.MOV");
  mov.loop();
```

Lines 27-30: instead of reading, copying, and, if necessary, resizing the next camera frame

```processing
  if(cam.available()) {
    cam.read();
  }
  input_rectangle.img.copy(cam, 0, 0, 640, 480, 0, 0, 640, 480);
```

read, copy, and resize the next movie frame (in this example, the movie has 1920x1080 resolution; use the actual resolution of your movie):

```processing
  if(mov.available()) {
    mov.read();
  }
  input_rectangle.img.copy(mov, 0, 0, 1920, 1080, 0, 0, 640, 480);
```
