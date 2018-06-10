
import processing.video.*;

Capture cam;

MasterConfig current_run;

DataRectangle input_rectangle;

boolean black_and_white, inverted, fluid_reference;

int base_frame_count;

void setup () {
  current_run = new MasterConfig();
  input_rectangle = may_8_graph(current_run);
  //may_9_graph(current_run);
  cam = new Capture(this, 640, 480, 30);
  cam.start();
  black_and_white = false;
  inverted = false;
  fluid_reference = false;
}

void draw () {
  background (127);
    if(cam.available()) {
    cam.read();
  }
  input_rectangle.img.copy(cam, 0, 0, 640, 480, 0, 0, 640, 480);
  if (inverted) input_rectangle.img.filter(INVERT);
  if (black_and_white) input_rectangle.img.filter(GRAY);
  current_run.draw_images();
  current_run.apply_transforms();
  current_run.shift_data();
  if (fluid_reference) {
     textSize(42);
     float fade = min((frameCount-base_frame_count)/100.0,1.0);
     float back = 1 - fade;
     fill(back*127+fade*255, back*127, back*127+fade*255);
     text("github.com/anhinga/fluid => atparty-2018 => surreal webcam", 10, 498); 
  }
}

void mousePressed() {
  current_run.try_controls(mouseX, mouseY);
}

void mouseDragged() {
  current_run.try_controls(mouseX, mouseY);
}

void keyPressed() {
  if (key == 'b' || key == 'B') black_and_white = !black_and_white;
  if (key == 'i' || key == 'I') inverted = !inverted;
  if (key == 'f' || key == 'F') {
    fluid_reference = !fluid_reference;
    base_frame_count = frameCount;
  }
}
