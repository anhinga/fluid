// Class for dynamically evolving the program

// In the current version, it just codes some fixed logic of evolving the program,
// so it is a demo version of such an editor

class ProgramEditor {
  
  PImage fall_forest_image;
  
  DataFlowGraph wave_graph_template;
  
  DataFlowGraph negation_graph_template;
  
  ProgramEditor() {
    
    // load images
    
    fall_forest_image = loadImage("Before elections 015.JPG");
 
    // make small graph templates 
    
    //   make wave graph template
    
    wave_graph_template = new DataFlowGraph(0, 0);
    
    DataFlowVertex fall_forest = make_image_vertex(wave_graph_template, 0, 500, 450, 450, true, fall_forest_image);
    
    DataFlowVertex wave_target = new DataFlowVertex(wave_graph_template, 0, 0, 450, 450, true);
    VDID_CustomWaveTransform wave_target_data = new VDID_CustomWaveTransform();
    wave_target.set_vertex_data(wave_target_data);
    wave_target_data.initialize_from_image(fall_forest_image);
        
    
    wave_graph_template.add_vertex(fall_forest);
    wave_graph_template.add_vertex(wave_target);
    wave_target.add_source(fall_forest);
    
    //   make negation graph template; duplication of pattern here is annoying, but we'll think more about it

    negation_graph_template = new DataFlowGraph(0, 0);
    
    DataFlowVertex fall_forest_2 = make_image_vertex(negation_graph_template, 0, 500, 450, 450, true, fall_forest_image);
    
    DataFlowVertex negation_target = new DataFlowVertex(negation_graph_template, 0, 0, 450, 450, true);
    VDID_NegationTransform negation_target_data = new VDID_NegationTransform();
    negation_target.set_vertex_data(negation_target_data);
    negation_target_data.initialize_from_image(fall_forest_image);
        

    negation_graph_template.add_vertex(fall_forest_2);
    negation_graph_template.add_vertex(negation_target);
    negation_target.add_source(fall_forest_2);
    
    
  }
  
  void tweak_optionally(DataFlowGraph program) {
    
    // the analysis here is based on "frameCount"
    // (one could also keep track of what's already done)
    
    // attention: frameCount starts with 1, not with 0


    if (frameCount == 1) { 
      println("Adding wave graph");
      program.add_subgraph(wave_graph_template.limited_deep_copy(10, 25));
    } 
    
    if (frameCount == 100) {
      println("Adding negation graph");
      program.add_subgraph(negation_graph_template.limited_deep_copy(510, 25));      
    }
    
    /* if (frameCount >= 100 && frameCount <= 600)
         main.subgraphs[0].target_nodes[1].move_image(1,1); */
         
    if (frameCount == 200) {
      println("Special insert");
      special_insert(main.subgraphs[1].target_nodes[0], main.subgraphs[0].target_nodes[1], -200, 0, true); 
    }
    
    if (frameCount > 300 && frameCount <= 400) {
      VDID_SumOf2Transform sum_of_2_data = (VDID_SumOf2Transform)main.subgraphs[1].target_nodes[0].vertex_data;
      sum_of_2_data.interpolation_coef = (frameCount - 300)/100.0;
    }
    
    if (frameCount > 400 && frameCount <= 450) {
      VDID_SumOf2Transform sum_of_2_data = (VDID_SumOf2Transform)main.subgraphs[1].target_nodes[0].vertex_data;
      sum_of_2_data.interpolation_coef = (500-frameCount)/100.0;
    }
         
  }
  
  
  DataFlowVertex make_image_vertex(DataFlowGraph parent, int left_x, int left_y, int size_x, int size_y, boolean visible, PImage _image) {
    // the order of operators is important here (unfortunately)
    DataFlowVertex new_vertex = new DataFlowVertex(parent, left_x, left_y, size_x, size_y, visible);
    VertexDataImage img_new_vertex = new VertexDataImage();
    new_vertex.set_vertex_data(img_new_vertex);
    img_new_vertex.initialize_from_image(_image);
    return new_vertex;    
  }
  
  // special insert is a hallmark of our calculus
  // We have DataFlowVertex target_vertex, and it contains vertex_data.
  // The new_vertex is created and it will now contain vertex_data instead.
  // The target_vertex will now contain linear combination of 
  //                       new_vertex (coefficient initialized to 1.0) and 
  //                       side_vertex (coefficient initialized to 0.0)
  // new_vertex will get the same parent DataFlowGraph as target_vertex
  // (the operation should be invertible when one of the coefficients is 0.0
  //  if the vertices to be glued together share the same parent graph;
  //  otherwise we are not sure)
  // Returns new_vertex for the unlikely event that you want it
  // COORDS: the new_changes the coords, and might turn off visibility
  DataFlowVertex special_insert(DataFlowVertex target_vertex, DataFlowVertex side_vertex, int delta_x, int delta_y, boolean visibility_off_for_new_vertex) {
    DataFlowVertex new_vertex = new DataFlowVertex(target_vertex.parent, target_vertex.left_x+delta_x, target_vertex.left_y+delta_y, 
                                                   target_vertex.size_x, target_vertex.size_y, 
                                                   target_vertex.visible && !visibility_off_for_new_vertex);
    new_vertex.sources = target_vertex.sources;
    target_vertex.sources = new DataFlowVertex[0];
    VDID_SumOf2Transform sum_of_2_data = new VDID_SumOf2Transform();
    new_vertex.set_vertex_data(target_vertex.vertex_data);
    target_vertex.set_vertex_data(sum_of_2_data);
    sum_of_2_data.initialize_from_image(fall_forest_image);
    target_vertex.add_source(new_vertex); 
    target_vertex.add_source(side_vertex);
    sum_of_2_data.interpolation_coef = 0.0; // nothing changes at the beginning
    target_vertex.parent.add_vertex(new_vertex);
    return new_vertex;                                               
  }
}
