// vertex_data_image_dynamic with custom_wave_transform


class VDID_CustomWaveTransform extends VertexDataImageDynamic {
  
  float distance_coef;

  // control  
  int frame_count_base;
  int center_x;
  int center_y;

  VDID_CustomWaveTransform () {
    super();
    distance_coef = 1.0;
  }
  
  void activate_control() {
    frame_count_base = 0; 
    center_x = my_vertex.size_x/2;
    center_y = my_vertex.size_y/2;
  }
  
  VDID_CustomWaveTransform aux_copy() {
    // overrides superclass
    VDID_CustomWaveTransform new_vertex_data = new VDID_CustomWaveTransform();
    copy_images(new_vertex_data);
    return new_vertex_data;
  }
  
  void set_distance_coef (float _distance_coef) {
    distance_coef = _distance_coef;
  } 
  
  void apply_transform() {

    int effective_frame_count = frameCount - frame_count_base; 
    
    float shift = effective_frame_count/(1+0.01*effective_frame_count);
    
    
    
    int output_width = my_vertex.size_x;
    int output_height = my_vertex.size_y;    
    
    int input_width = my_vertex.sources[0].size_x;
    int input_height = my_vertex.sources[0].size_y;
    
    VertexDataImage input = (VertexDataImage)my_vertex.sources[0].vertex_data;
    
    assert input.isVertexDataImage();
    
    for (int i = 0; i < output_width; i++)
      for (int j = 0; j < output_height; j++) {
        
          float d = dist(i,j,center_x,center_y);
          float mod = 0.25*sin(distance_coef*(d/effective_frame_count+shift))+0.75;
          int i1 = int( (center_x + (i-center_x)*mod)*input_width/output_width );
          int j1 = int( (center_y + (j-center_y)*mod)*input_height/output_height );
          color c = input.get_color_point(i1,j1);
          set_color_point(i,j,c);
      } 
  }
  
  void click(int relative_click_x, int relative_click_y) {
    frame_count_base = frameCount;
    center_x = relative_click_x;
    center_y = relative_click_y;
  }

}

