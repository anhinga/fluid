// vertex_data_image_dynamic with sum_of_2_transform

class VDID_SumOf2Transform extends VertexDataImageDynamic {
  
  float interpolation_coef;

  VDID_SumOf2Transform () {
    super();
    interpolation_coef = 0.5; 
  }
  
  VDID_SumOf2Transform aux_copy() {
    // overrides superclass
    VDID_SumOf2Transform new_vertex_data = new VDID_SumOf2Transform();
    copy_images(new_vertex_data);
    return new_vertex_data;
  }
  
  void set_coef (float _coef) {
    interpolation_coef = _coef;
  } 
  
  float transform_click_y_to_value (int click_y) {
    
    int control_height = my_vertex.size_y;
    int inverted_click_y = control_height - click_y;
    float delta = inverted_click_y - 0.1*control_height;
    if (delta < 0.0) delta = 0.0;
    delta = delta/(0.8*control_height);
    if (delta > 1.0) delta = 1.0;
    return delta; 
  }
  
  void apply_transform() {

    int output_width = my_vertex.size_x;
    int output_height = my_vertex.size_y;
    
    int input1_width = my_vertex.sources[0].size_x;
    int input1_height = my_vertex.sources[0].size_y;    
    int input2_width = my_vertex.sources[1].size_x;
    int input2_height = my_vertex.sources[1].size_y;
    
    assert output_width == input1_width;
    assert output_height == input1_height;
    assert output_width == input2_width;
    assert output_height == input2_height;
    
    VertexDataImage input1 = (VertexDataImage)my_vertex.sources[0].vertex_data;    
    assert input1.isVertexDataImage();
    VertexDataImage input2 = (VertexDataImage)my_vertex.sources[1].vertex_data;    
    assert input2.isVertexDataImage();
    
    for (int i = 0; i < output_width; i++)
      for (int j = 0; j < output_height; j++) {
          color c1 = input1.get_color_point(i,j);
          color c2 = input2.get_color_point(i,j);
          color c = lerpColor(c1, c2, interpolation_coef);
          set_color_point(i,j,c);
      }
  
  }

  void click(int relative_click_x, int relative_click_y) {
    interpolation_coef = transform_click_y_to_value(relative_click_y);
  }
}

