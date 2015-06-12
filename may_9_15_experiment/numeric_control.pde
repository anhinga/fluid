class NumericControl extends ClickControl {
  float value;
  
  DataRectangle rect;

  
  NumericControl(int _left_x, int _left_y, int _control_width, int _control_height) {
    super(_left_x, _left_y, _control_width, _control_height); 
    value = 0.5;
    rect = new DataRectangle();
    rect.img = createImage(_control_width, _control_height, RGB);
    rect.rect_width = _control_width;
    rect.rect_height = _control_height;
    color c = color(180);
    for (int i = 0; i < _control_width; i++)
      for (int j = 0; j < control_height; j++)
        rect.img.set(i,j,c);
    
    render();    
  }
  
  float transform_click_y_to_value (int click_y) {
    
    int inverted_click_y = control_height - click_y;
    float delta = inverted_click_y - 0.1*control_height;
    if (delta < 0.0) delta = 0.0;
    delta = delta/(0.8*control_height);
    if (delta > 1.0) delta = 1.0;
    return delta; 
  }
  
  void click(int click_x, int click_y) {
    
    value = transform_click_y_to_value (click_y);
    println("control set to ", value);
 
    //println("frameRate is ", frameRate); 
    //frameRate(frameRate*5*value); 
    
    render();
  } 
  
  void render() {
    color white = color(255);
    color black = color(0);
    color c = lerpColor(black, white, value);
    for (int i = control_width/5; i < 2*control_width/5; i++)
      for (int j = control_height/10; j < 9*control_height/10; j++)
        rect.img.set(i,j,c);
        
    for (int i = 3*control_width/5; i < 4*control_width/5; i++)
      for (int j = control_height/10; j < 9*control_height/10; j++) {
         float v = transform_click_y_to_value(j);
         if (v <= value)
           rect.img.set(i,j,black);
         else
           rect.img.set(i,j,white);
      }

  }
}
