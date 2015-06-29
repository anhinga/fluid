// content of the dynamic node 

// associated transform to be added in the derived classes

class VertexDataImageDynamic extends VertexDataImage {
  
  PImage img_write;

  VertexDataImageDynamic () {
    super(); 
  }


  
  void initialize_from_image(PImage _image) {
    super.initialize_from_image(_image);
    img_write = img.get();
  }
  
  void initialize_from_file(String file_name) {
    super.initialize_from_file(file_name);
    img_write = img.get();
  }

  void copy_images(VertexDataImageDynamic new_vertex_data) {
    new_vertex_data.img = img.get(); // we are not really planning to change content of this image, but who knows, so let's actually copy
    new_vertex_data.img_write = img_write.get(); // we are not really planning to change content of this image, but who knows, so let's actually copy    
  }
   
  VertexDataImageDynamic aux_copy() {
    // overrides superclass
    VertexDataImageDynamic new_vertex_data = new VertexDataImageDynamic();
    copy_images(new_vertex_data);
    return new_vertex_data;
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

