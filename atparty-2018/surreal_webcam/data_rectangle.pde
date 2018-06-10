// file should be renamed

class DataRectangle {

  int rect_width;
  int rect_height;
  
  PImage img;

  color get_color_point (int i, int j) {
    return img.get(i,j);
  }

  void describe(int _width, int _height) {
    rect_width = _width;
    rect_height = _height;
    img = createImage(rect_width, rect_height, RGB);
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      img.pixels[i] = color(127, 127, 127); 
    }
    img.updatePixels();
  }

  void describe(int _width, int _height, String file_name) {
    rect_width = _width;
    rect_height = _height;
    img = loadImage(file_name);
    img.resize(rect_width, rect_height);
  }
  
}
