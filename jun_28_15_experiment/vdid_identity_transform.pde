// vertex_data_image_dynamic with identity_transform

// keep all those checks for now

class VDID_IdentityTransform extends VertexDataImageDynamic {
  


  VDID_IdentityTransform () {
    super();
  }
  
  VDID_IdentityTransform aux_copy() {
    // overrides superclass
    VDID_IdentityTransform new_vertex_data = new VDID_IdentityTransform();
    copy_images(new_vertex_data);
    return new_vertex_data;
  }
  
  void draw_symbolic(int context_x, int context_y, int font_size) {
    textSize(font_size);
    fill(0);
    text("Id", context_x, context_y);   
  }  
  
  void apply_transform() {
    
    int output_width = my_vertex.size_x;
    int output_height = my_vertex.size_y;
    
    int input_width = my_vertex.sources[0].size_x;
    int input_height = my_vertex.sources[0].size_y;
    
    assert output_width == input_width;
    assert output_height == input_height;
    
    VertexDataImage input = (VertexDataImage)my_vertex.sources[0].vertex_data;
    
    assert input.isVertexDataImage();
    
    img_write = input.img.get();

  }

}

