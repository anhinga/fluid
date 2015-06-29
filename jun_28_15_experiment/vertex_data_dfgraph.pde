// content of the node being a dataflow graph

// first stage - to use this to make the dataflow program
// a node of itself into to visualize its evolution

// further plans - to make this into a controller,
// and to enable dependency on the other nodes of a graph

class VertexDataDFGraph extends VertexData {
  
  DataFlowGraph df_graph;
  
  VertexDataDFGraph () {
    super(); 
  }
  
  // set a reference to an existing data flow graph
  void set_df_graph(DataFlowGraph _df_graph) {
    df_graph = _df_graph;
  }
  
  // get a reference to the data flow graph in this node
  DataFlowGraph get_df_graph() {
    return df_graph;
  }

  // The goal of this is to visualize the current state of df_graph
  // We'd like the vertices to be positioned so as to mimic the location
  // of their associated rectangles, but at smaller scale
  //
  // One problem currently is that current the size info in the graph
  // is commented out; and just the global window is used
  //   
  void draw_image(int context_x, int context_y) {
    if (my_vertex.visible) {
      stroke(0);
      noFill();
      rect(context_x+my_vertex.left_x, context_y+my_vertex.left_y, my_vertex.size_x, my_vertex.size_y);
      float coef = 0.3;
      float ratio = 1.0;
      ratio = ratio * my_vertex.size_x / my_vertex.parent.size_x;
      df_graph.draw_symbolic(context_x+my_vertex.left_x, context_y+my_vertex.left_y, coef, ratio);
      df_graph.draw_edges();
    }
  }

  void draw_symbolic(int context_x, int context_y, int font_size) {
    textSize(font_size);
    fill(0);
    text("@", context_x, context_y);   
  } 
  
/*  we'll need to figure out eventually, what to do with all these functions,
    if we want full-blown higher-order dataflow programming
    
    Our starting point is draw_image
    
    
  VertexData aux_copy() {
    // override
  }
  
  void apply_transform() {
    // override
  }
  
  void shift_data() {
    // override
  }
  
  void click(int relative_click_x, int relative_click_y) {
    // override
  }
  
  void activate_control() {
    // override
  }
*********************************/
}
