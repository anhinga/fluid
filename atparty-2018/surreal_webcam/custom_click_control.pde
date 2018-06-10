class CustomClickControl extends ClickControl{
  int frame_count_base;
  int center_x;
  int center_y;
  
  CustomClickControl(int _left_x, int _left_y, int _control_width, int _control_height) {
    super(_left_x, _left_y, _control_width, _control_height); 
    center_x = _control_width/2;
    center_y = _control_height/2;
    frame_count_base = 0; 
  }
  
  void click(int click_x, int click_y) {
    frame_count_base = frameCount;
    center_x = click_x;
    center_y = click_y;
  } 
}
