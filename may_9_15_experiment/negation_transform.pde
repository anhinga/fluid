// Shapes for input and output must be equal for the time being

class NegationTransform extends Transform {
  
  DataRectangle input;
  DataRectangleDynamic output;
 
  NegationTransform(DataRectangle _input, DataRectangleDynamic _output) {
    input = _input;
    output = _output;
  } 
    
  void apply() {
    assert output.rect_width == input.rect_width;
    assert output.rect_height == input.rect_height;
    output.img_write = input.img.get();  
    output.img_write.filter(INVERT);
  }
}
