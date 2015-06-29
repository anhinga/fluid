
DataFlowGraph main;
ProgramEditor editor;

void setup () {
  main = new DataFlowGraph(10, 10, 1500, 1000, true);
  editor = new ProgramEditor();
  
  size(1520, 1020); // I don't know yet where to put this
}

void draw () {
  background (127);
  main.work_cycle(0, 0);
  editor.tweak_optionally(main);
}

void mousePressed() {
  main.try_controls(mouseX, mouseY, 0, 0);
}

void mouseDragged() {
  main.try_controls(mouseX, mouseY, 0, 0);
}
