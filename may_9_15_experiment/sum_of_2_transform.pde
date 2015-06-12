// Shapes for input and output must be equal for the time being

class SumOf2Transform extends Transform {
  
  DataRectangle input1;
  DataRectangle input2;
  DataRectangleDynamic output;
  NumericControl control;
 
  SumOf2Transform(DataRectangle _input1, DataRectangle _input2, DataRectangleDynamic _output, NumericControl _control) {
    input1 = _input1;
    input2 = _input2;
    output = _output;
    control = _control;
  } 
    
  void apply() {
    int output_width = output.rect_width;
    int output_height = output.rect_height;
    assert output_width == input1.rect_width;
    assert output_height == input1.rect_height;
    assert output_width == input2.rect_width;
    assert output_height == input2.rect_height;
    float interpolation = control.value;
    for (int i = 0; i < output_width; i++)
      for (int j = 0; j < output_height; j++) {
          color c1 = input1.get_color_point(i,j);
          color c2 = input2.get_color_point(i,j);
          color c = lerpColor(c1, c2, interpolation);
          output.set_color_point(i,j,c);
      }

  }
}
