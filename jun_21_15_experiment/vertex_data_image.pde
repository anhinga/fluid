// content of the constant node associated with a fixed image
// (the node is still categorized as a "target node" in the brave new world of "limited_deep_copy")

// eventually we might add a controller here for the purpose of image selection
//
// if we do that we might rethink draw_image for this type of node

class VertexDataImage extends VertexData {
  
  PImage img;

  VertexDataImage () {
    super(); 
  }
  
  boolean isVertexDataImage () {
    return true;
  }
  
  PImage get_image_reference() {
    return img;
  }
  
  PImage get_image_copy() {
    return img.get();
  }
  
  color get_color_point (int i, int j) {
    return img.get(i,j);
  }

  void initialize_from_image(PImage _image) {
    img = _image.get();
    img.resize(my_vertex.size_x, my_vertex.size_y);
  }
  
  void initialize_from_file(String file_name) {
    img = loadImage(file_name);
    img.resize(my_vertex.size_x, my_vertex.size_y);
  }
   
  VertexDataImage aux_copy() {
    // overrides superclass
    VertexDataImage new_vertex_data = new VertexDataImage();
    new_vertex_data.img = img.get(); // we are not really planning to change content of this image, but who knows, so let's actually copy
    return new_vertex_data;
  }
  
  void draw_image(int context_x, int context_y) {
    if (my_vertex.visible)
      image(img, context_x+my_vertex.left_x, context_y+my_vertex.left_y);
  }
  
 
}

