// vertex_data_image_dynamic with negation_transform


class VDID_NegationTransform extends VertexDataImageDynamic {
  


  VDID_NegationTransform () {
    super();
  }
  
  VDID_NegationTransform aux_copy() {
    // overrides superclass
    VDID_NegationTransform new_vertex_data = new VDID_NegationTransform();
    copy_images(new_vertex_data);
    return new_vertex_data;
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
    
    //img_write = input.img.get();
    img_write = input.get_image_copy();
    img_write.filter(INVERT);

  }

}

