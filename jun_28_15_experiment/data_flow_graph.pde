// data flow graph capable of containing subgraphs and of dynamic change

class DataFlowGraph {
  
  DataFlowVertex target_nodes[];
  DataFlowGraph subgraphs[];
  int left_x; // relative
  int left_y; // relative
  int size_x;
  int size_y;
  boolean visible;
  
  
  DataFlowGraph (int _left_x, int _left_y, int _size_x, int _size_y, boolean _visible) {
    target_nodes = new DataFlowVertex[0];
    subgraphs = new DataFlowGraph[0];
    left_x = _left_x;
    left_y = _left_y; 
    size_x = _size_x;
    size_y = _size_y;
    visible = _visible;
  }

  DataFlowVertex add_vertex(DataFlowVertex target_node) {
    target_nodes = (DataFlowVertex[]) append(target_nodes, target_node);
    return target_node;
  }
  
  DataFlowGraph add_subgraph(DataFlowGraph subgraph) {
    subgraphs = (DataFlowGraph[]) append(subgraphs, subgraph);
    return subgraph;
  }
  
  /******* Auxiliary functions ****************************************************************************/
  
  // auxiliary function, a helper to limited_deep_copy
  // the resulting graph is not ready for use yet
  //
  // the memory handling logic here is only good for small examples,
  // because of the way "append" is used above
  //
  DataFlowGraph aux_recursive_copy(int delta_x, int delta_y) {
    DataFlowGraph new_copy = new DataFlowGraph(left_x + delta_x, left_y + delta_y, size_x, size_y, visible);
    for (int i = 0; i < target_nodes.length; i++)
      new_copy.add_vertex(target_nodes[i].aux_copy(new_copy));
    for (int i = 0; i < subgraphs.length; i++)
      new_copy.add_subgraph(subgraphs[i].aux_recursive_copy(0, 0)); 
    return new_copy;      
  }
  
  //auxiliary function, a helper to limited deep copy
  void update_sources() {
    for (int i = 0; i < target_nodes.length; i++)
      target_nodes[i].update_sources();
    for (int i = 0; i < subgraphs.length; i++)
      subgraphs[i].update_sources();    
  }
  
  //auxiliary function, a helper to limited deep copy
  void reset_forward_source_references() {
    for (int i = 0; i < target_nodes.length; i++)
      target_nodes[i].reset_forward_source_reference();
    for (int i = 0; i < subgraphs.length; i++)
      subgraphs[i].reset_forward_source_references();    
  }
  
  // auxiliary function for the work cycle, main computation
  void apply_transforms () {
    for (int i = 0; i < target_nodes.length; i++)
      target_nodes[i].apply_transform();
    for (int i = 0; i < subgraphs.length; i++)
      subgraphs[i].apply_transforms();     
  }
  
  // auxiliary function for the work cycle, shifting computed data back
  void shift_data () {
    for (int i = 0; i < target_nodes.length; i++)
      target_nodes[i].shift_data();
    for (int i = 0; i < subgraphs.length; i++)
      subgraphs[i].shift_data();     
  }
  
  // auxiliary function for the work cycle, actually drawing
  void draw_images (int context_x, int context_y) {
    int new_context_x = context_x + left_x;
    int new_context_y = context_y + left_y;
    for (int i = 0; i < target_nodes.length; i++)
      target_nodes[i].draw_image(new_context_x, new_context_y);
    for (int i = 0; i < subgraphs.length; i++)
      subgraphs[i].draw_images(new_context_x, new_context_y);     
  }
 
  // to draw the graph as a program (nodes only)
  void draw_symbolic (int context_x, int context_y, float coef, float ratio) {
    int new_context_x = context_x + (int)(ratio*left_x);
    int new_context_y = context_y + (int)(ratio*left_y);
    int new_size_x = (int)(ratio*size_x)-20; // -20 is a hack for a not-well-understood situation
    int new_size_y = (int)(ratio*size_y);
    stroke(100);
    noFill();
    rect(new_context_x, new_context_y, new_size_x, new_size_y);
    stroke(0);
    for (int i = 0; i < target_nodes.length; i++)
      target_nodes[i].draw_symbolic(new_context_x, new_context_y, coef, ratio);
    for (int i = 0; i < subgraphs.length; i++)
      subgraphs[i].draw_symbolic(new_context_x, new_context_y, coef, ratio);     
  } 
  
  
  // to draw the graph as a program (edges only; must be called after draw_symbolic)
  void draw_edges () {
    for (int i = 0; i < target_nodes.length; i++)
      target_nodes[i].draw_edges();
    for (int i = 0; i < subgraphs.length; i++)
      subgraphs[i].draw_edges();     
  } 
  
  /********** Public functions ****************************************************************************/
  
  // The target_nodes are all copied, the references to external sources are kept, 
  // the references to sources within the graph are updated per deep_copy metaphor.
  // The outgoing links are not explicitly represented in this implementation,
  // hence the outgoing external links are omitted in the new copy, just as we want.
  DataFlowGraph limited_deep_copy (int delta_x, int delta_y) {
    DataFlowGraph new_copy = aux_recursive_copy(delta_x, delta_y);
    new_copy.update_sources();
    reset_forward_source_references(); 
    return new_copy;
  }
  
  void work_cycle (int context_x, int context_y) {
    apply_transforms();
    shift_data();
    draw_images(context_x, context_y);    
  }
  
  void try_controls(int click_x, int click_y, int context_x, int context_y) {
    int new_context_x = context_x + left_x;
    int new_context_y = context_y + left_y;
    for (int i = 0; i < target_nodes.length; i++)
      target_nodes[i].try_controls(click_x, click_y, new_context_x, new_context_y);
    for (int i = 0; i < subgraphs.length; i++)
      subgraphs[i].try_controls(click_x, click_y, new_context_x, new_context_y);     
  }  
  
}
