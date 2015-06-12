//file should be renamed

class DataRectangleDynamic extends DataRectangle {
  
  PImage img_write;
  
  void describe(int _width, int _height) {
    super.describe(_width, _height);
    img_write = img.get();
  }

  void set_color_point (int i, int j, color c) {
    img_write.set(i,j,c);
  }
  
  void shift_data () {
    PImage img_tmp = img;
    img = img_write;
    img_write = img_tmp; 
  }
}
