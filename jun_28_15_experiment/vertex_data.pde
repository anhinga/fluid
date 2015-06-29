// base class for content of the vertex: data, associated transform, controller(s) if any

// classes describing actual content should be inherited from this one

class VertexData {
  
  DataFlowVertex my_vertex;
  
  VertexData () {
    my_vertex = null; // unusable until set    
  }

  // dynamic checks of type safety  
  boolean isVertexDataImage () {
    return false;
  }
  
  boolean isVertex_VDID_SumOf2Transform() {
    return false;
  }
  
  float get_interpolation_coef() {
    return 0.5;
  }
  
  VertexData aux_copy() {
    // override
    return new VertexData();
  }
  
  void apply_transform() {
    // override
  }
  
  void shift_data() {
    // override
  }
  
  void draw_image(int context_x, int context_y) {
    // override
  }
  
  void draw_symbolic(int context_x, int context_y, int font_size) {
    // override         
  } 
  
  void click(int relative_click_x, int relative_click_y) {
    // override
  }
  
  void activate_control() {
    // override
  }
}
