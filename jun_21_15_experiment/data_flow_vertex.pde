// target node, with its associated transform, sources if any, and controller(s) and references to sources

// this is a container, not a base class 
//
// the reason for this is that we have a transform in our algebra ("special insert")
// which changes the content of a node

// in particular, a node might eventually be not just an image,
// but something else, for example it might be a graph,
// which is why we are not putting the image fields here

// but we do believe that basic imaging parameters are associated with every type of node,
// e.g. visible or not and the associated rectangle, so we include those here

class DataFlowVertex {
  
  DataFlowGraph parent;
  
  DataFlowVertex forward_source_reference;
  int left_x; // relative
  int left_y; // relative
  int size_x;
  int size_y;
  boolean visible;
  
  VertexData vertex_data; // content of the vertex: data, associated transform, controller(s) if any
  
  DataFlowVertex sources[]; // 0 or more sources 
  
  DataFlowVertex (DataFlowGraph _parent, int _left_x, int _left_y, int _size_x, int _size_y, boolean _visible) {
    reset_forward_source_reference(); 
    
    parent = _parent;
    left_x = _left_x;
    left_y = _left_y;
    size_x = _size_x;
    size_y = _size_y;
    visible = _visible;
    
    sources = new DataFlowVertex[0];
  }
  
  void set_vertex_data(VertexData data) {
    vertex_data = data;
    vertex_data.my_vertex = this;
    vertex_data.activate_control();
  }
  
  void add_source (DataFlowVertex source) {
    sources = (DataFlowVertex[])append(sources, source);
  }
  
  void reset_forward_source_reference() {
    forward_source_reference = null;
  }
  
  DataFlowVertex aux_copy(DataFlowGraph parent) {
    DataFlowVertex new_vertex = new DataFlowVertex(parent, left_x, left_y, size_x, size_y, visible);
    VertexData new_vertex_data = vertex_data.aux_copy();
    new_vertex.set_vertex_data(new_vertex_data);
    for (int i =0; i < sources.length; i++)
      new_vertex.add_source(sources[i]);
    forward_source_reference = new_vertex;
    return new_vertex;
  }
  
  void update_sources() {
    // when a source is pointing to something which has a forward reference set,
    // point this source to the value of this forward reference instead
    for (int i =0; i < sources.length; i++)
      if (sources[i].forward_source_reference != null)
        sources[i] = sources[i].forward_source_reference;
  }
  
  void apply_transform() {
    vertex_data.apply_transform();
  }
  
  void shift_data() {
    vertex_data.shift_data();
  }
  
  void draw_image(int context_x, int context_y) {
    vertex_data.draw_image(context_x, context_y);
  }

  void try_controls(int click_x, int click_y, int context_x, int context_y) {
    int current_left_x = context_x + left_x;
    int current_left_y = context_y + left_y;

    if (click_x >= current_left_x && click_y >= current_left_y &&
        click_x < current_left_x + size_x && click_y < current_left_y + size_y && visible) {          
                         vertex_data.click(click_x - current_left_x, click_y - current_left_y);
    }           
  }

  void move_image(int delta_x, int delta_y) {
    left_x = left_x + delta_x;
    left_y = left_y + delta_y;
  }  
}
