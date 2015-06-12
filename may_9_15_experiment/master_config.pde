// class holding the whole dataflow configuration

class MasterConfig {

  Transform[] transforms;
  DataRectangleDynamic[] rects;
  OutputDataRectangle[] images;
  ClickControl[] controls;
  
  MasterConfig () {
    transforms = new Transform[0];
    rects = new DataRectangleDynamic[0]; 
    images = new OutputDataRectangle[0];
    controls = new ClickControl[0];
  }
  
  void register_transform(Transform _transform) {
    transforms = (Transform[]) append(transforms, _transform);
  }
  
  void register_data(DataRectangleDynamic _data) {
    rects = (DataRectangleDynamic[]) append(rects, _data);
  }
  
  void register_output(int _left_x, int _left_y, DataRectangle _data) {
    images = (OutputDataRectangle[]) append(images, new OutputDataRectangle(_left_x, _left_y, _data)); 
  }
  
  void register_control(ClickControl _control) {
    controls = (ClickControl[]) append(controls, _control);
  }
  
  void apply_transforms() {
    for (int i = 0; i < transforms.length; i++)
      transforms[i].apply(); 
  }
  
  void shift_data() {
    for (int i = 0; i < rects.length; i++) 
      rects[i].shift_data();
  }
  
  void draw_images() {
    for (int i = 0; i < images.length; i++) {
      OutputDataRectangle cur_img = images[i];
      image(cur_img.data.img, cur_img.left_x, cur_img.left_y);
    }
  }
  
  void try_controls(int _mouse_x, int _mouse_y) {
    for (int i = 0; i < controls.length; i++) {
      ClickControl current = controls[i];
      if (_mouse_x >= current.left_x && 
          _mouse_y >= current.left_y &&
          _mouse_x < current.left_x + current.control_width &&
          _mouse_y < current.left_y + current.control_height) {
            
            current.click(_mouse_x - current.left_x, _mouse_y - current.left_y);
      }      
    }
     
  }  
}


