
MasterConfig current_run;

void setup () {
  current_run = new MasterConfig();
  may_8_graph(current_run);
  //may_9_graph(current_run);
}

void draw () {
  background (127);
  current_run.draw_images();
  current_run.apply_transforms();
  current_run.shift_data();
}

void mousePressed() {
  current_run.try_controls(mouseX, mouseY);
}

void mouseDragged() {
  current_run.try_controls(mouseX, mouseY);
}
