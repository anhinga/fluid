// file should be renamed

class DataRectangle {

  int rect_width;
  int rect_height;
  
  PImage img;

  color get_color_point (int i, int j) {
    return img.get(i,j);
  }

  void describe(int _width, int _height) {
    describe(_width, _height,  "code_waves.jpg");
  }

  void describe(int _width, int _height, String file_name) {
    rect_width = _width;
    rect_height = _height;
    img = loadImage(file_name);
    img.resize(rect_width, rect_height);
  }
  
}
