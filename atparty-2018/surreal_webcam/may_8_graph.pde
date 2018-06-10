DataRectangle may_8_graph(MasterConfig this_run) {

  int hor_size = 640;  
  int vert_size = 480;
  int margin_size = 5;
  int second_hor_size = hor_size+2*margin_size;
  int second_vert_size = vert_size+2*margin_size;
  int third_hor_size = 2*hor_size+3*margin_size;
  int third_vert_size = 2*vert_size+3*margin_size;
  int slider_width = 50;

  size (third_hor_size + slider_width + margin_size, third_vert_size);
  
  DataRectangle input_1 = new DataRectangle();  
  input_1.describe(hor_size, vert_size);
  //input_1.img.filter(INVERT);
  //input_1.img.filter(GRAY);
  
  DataRectangleDynamic layer_1_1 = new DataRectangleDynamic();  
  layer_1_1.describe(hor_size, vert_size);
  this_run.register_data(layer_1_1);
  
  DataRectangleDynamic layer_2_1 = new DataRectangleDynamic();  
  layer_2_1.describe(hor_size, vert_size);
  this_run.register_data(layer_2_1);
  
  DataRectangleDynamic layer_3_1 = new DataRectangleDynamic();  
  layer_3_1.describe(hor_size,vert_size);
  this_run.register_data(layer_3_1);
  
  DataRectangleDynamic layer_4_1 = new DataRectangleDynamic();  
  layer_4_1.describe(hor_size,vert_size);
  this_run.register_data(layer_4_1);
  
  DataRectangleDynamic layer_4_2 = new DataRectangleDynamic();  
  layer_4_2.describe(hor_size,vert_size);
  this_run.register_data(layer_4_2);
  
  this_run.register_output(margin_size, second_vert_size, layer_1_1);
  this_run.register_output(margin_size, margin_size, layer_3_1);
  this_run.register_output(second_hor_size, margin_size, layer_4_1);
  this_run.register_output(second_hor_size, second_vert_size, layer_4_2);
    
  CustomClickControl click_control_1 = new CustomClickControl(margin_size, second_vert_size, hor_size, vert_size);
  CustomClickControl click_control_2 = new CustomClickControl(margin_size, margin_size, hor_size, vert_size);
  NumericControl numeric_control_1 = new NumericControl (third_hor_size, margin_size, slider_width, vert_size);
  this_run.register_output(third_hor_size, margin_size, numeric_control_1.rect);
  NumericControl numeric_control_2 = new NumericControl (third_hor_size, second_vert_size, slider_width, vert_size);
  this_run.register_output(third_hor_size, second_vert_size, numeric_control_2.rect);
  
  this_run.register_control(click_control_1);
  this_run.register_control(click_control_2);
  this_run.register_control(numeric_control_1);
  this_run.register_control(numeric_control_2); 
 
  
  CustomWaveTransform transform_to_1 = new CustomWaveTransform(input_1, layer_1_1, click_control_1);
  this_run.register_transform(transform_to_1);
  transform_to_1.set_distance_coef(0.5);
  
  NegationTransform transform_to_2 = new NegationTransform(layer_1_1, layer_2_1);
  this_run.register_transform(transform_to_2);
  
  CustomWaveTransform transform_to_3 = new CustomWaveTransform(layer_2_1, layer_3_1, click_control_2);
  this_run.register_transform(transform_to_3);
  
  SumOf2Transform transform_to_4_1 = new SumOf2Transform(input_1, layer_3_1, layer_4_1, numeric_control_1);
  this_run.register_transform(transform_to_4_1);
  
  SumOf2Transform transform_to_4_2 = new SumOf2Transform(layer_1_1, layer_3_1, layer_4_2, numeric_control_2);
  this_run.register_transform(transform_to_4_2);
  
  return input_1;
  
}
