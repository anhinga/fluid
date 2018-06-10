// This class abstracts the wave transform used in my main demo, Fall 2014

class CustomWaveTransform extends Transform {
  
  DataRectangle input;
  DataRectangleDynamic output;
  CustomClickControl control;
  float distance_coef;
 
  CustomWaveTransform(DataRectangle _input, DataRectangleDynamic _output, CustomClickControl _control) {
    input = _input;
    output = _output;
    control = _control;
    distance_coef = 1.0;
  } 
  
  void set_distance_coef (float _distance_coef) {
    distance_coef = _distance_coef;
  } 
  
  void apply() {
    int effective_frame_count = frameCount - control.frame_count_base;
    float center_x = control.center_x;
    float center_y = control.center_y; 
    float shift = effective_frame_count/(1+0.01*effective_frame_count);
    int output_width = output.rect_width;
    int output_height = output.rect_height;
    int input_width = input.rect_width;
    int input_height = input.rect_height;
    for (int i = 0; i < output_width; i++)
      for (int j = 0; j < output_height; j++) {
          float d = dist(i,j,center_x,center_y);
          float mod = 0.25*sin(distance_coef*(d/effective_frame_count+shift))+0.75;
          int i1 = int( (center_x + (i-center_x)*mod)*input_width/output_width );
          int j1 = int( (center_y + (j-center_y)*mod)*input_height/output_height );
          color c = input.get_color_point(i1,j1);
          output.set_color_point(i,j,c);
      }    
  }
}
