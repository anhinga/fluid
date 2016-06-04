
// Configuration parameters in various combinations
// and the notes on those combinations first,
// then "setup" and "draw" Processing functions

// Experiment configuration; the board is a torus

int board_size = 64; //32;
int square_size = 10; //15;
float scale = 0.5;
float propagation_probability =  0.995;  // 0.999;;
int gap_size = 64; // specifies initial conditions (gap_size = board_size is for the black initial board,
                   //                              (gap_size = 1 is for the white initial board)
int[][] arr_connect = {{1,0},{0,1},{-1,-1}}; // try different ones!
float KOEF = 1./float(arr_connect.length); // normalization coefficient
int stopFrame = 250; // stop after this many frames, so that one can see the static image
int my_frame_rate = 20;
boolean amplify_brightness = true; // set to false to turn it off
float amplify_for_dark = 2.0; // additional amplification for dark images, set for 1.0 to turn it off


/******** The default configuration (revert the above to this, if necessary)
int board_size = 64; //32;
int square_size = 10; //15;
float propagation_probability =  0.995;  // 0.999;;
int gap_size = 64; // specifies initial conditions (gap_size = board_size is for the black initial board,
                   //                              (gap_size = 1 is for the white initial board)
int[][] arr_connect = {{1,0},{0,1},{-1,-1}}; // try different ones!
float KOEF = 1./float(arr_connect.length); // normalization coefficient
int stopFrame = 250; // stop after this many frames, so that one can see the static image
int my_frame_rate = 10;
boolean amplify_brightness = true; // set to false to turn it off
float amplify_for_dark = 2.0; // additional amplification for dark images, set for 1.0 to turn it off

************************************/

/******** Another particularly interesting configuration - different image each time
int board_size = 64; //32;
int square_size = 10; //15;
float propagation_probability =  0.995;  // 0.999;;
int gap_size = 6; // specifies initial conditions (gap_size = board_size is for the black initial board,
                   //                              (gap_size = 1 is for the white initial board)
int[][] arr_connect = {{4,0},{-4,0},{1,1}, {-1,-1}}; // try different ones!
float KOEF = 1./float(arr_connect.length); // normalization coefficient
int stopFrame = 250; // stop after this many frames, so that one can see the static image
int my_frame_rate = 10;
boolean amplify_brightness = false;
float amplify_for_dark = 1.0;
************************************/

/******* Another configuration with an interesting diverse dynamics
int board_size = 64; //32;
int square_size = 10; //15;
float propagation_probability =  0.995;  // 0.999;;
int gap_size = 64; // specifies initial conditions (gap_size = board_size is for the black initial board,
                   //                              (gap_size = 1 is for the white initial board)
int[][] arr_connect = {{8,0},{0,8},{8,8}, {-8,-8}}; // try different ones!
float KOEF = 1./float(arr_connect.length); // normalization coefficient
int stopFrame = 250; // stop after this many frames, so that one can see the static image
int my_frame_rate = 10;
boolean amplify_brightness = false;
float amplify_for_dark = 1.0;
*************************************/



// Further remarks on some of the experiment configurations

/*************   to try arr_connect =:
//###
{{1,0},{0,1},{-1,-1}}; 
// at prob 0.995, gap 64, wandering clouds emerging from the black background, 
//                    some containing different diagonal patterns of period 3;
// at prob 1, gap 3 has stable state, fading into uniform gray by 3000 steps
// other gaps black out immediately


//###
{{4,0},{-4,0},{1,1}, {-1,-1}};
prob = 1: different stable patterns for gap=2,4,8
prob. 0.995: for gap =1 or gap =board_size, hard to define broad stripes of conflicting patterns 
for gap = 6 or 8, same, i.e. seems to almost but not quite override stable background patterns.
I ran  6 twice - both were exceedingly varied, with emerging and vanishing patterns
for gap=2 or 4, stable background is too powerful to be overridden

//##
{{8,0},{0,8},{8,8}, {-8,-8}};
// tiling by identical 8x8 squares, square appearance can be anything
// when the gap =1, or gap =board_size

//##
{{0,0},{1,0},{0,1},{1,1}, {-1,-1}}; // wandering clouds; no stable state, 
                                    // gap values 1 and 2 are good for observations


MORE NOTES ON VARIOUS CONFIGURATIONS WILL BE ADDED SOON

******************************************************************************************/

import java.util.Map;

HashMap<String, Argument> arguments;
HashMap<String, Operation> operations;
HashMap<String, OpCoef> matrix_elements; // global dictionary of matrix elements is needed for higher-order programming


String cell_name (int i, int j) {
  return str(i)+":"+str(j); 
}

PImage init_img;

void setup () {
  int my_size = board_size*square_size;
  size(my_size, my_size);
  
  background(127);
  noStroke();
  colorMode(RGB, 2.0); // we map color segment [-1,1] ([black:white]) into segment [0,2] 
  
  frameRate(my_frame_rate);
  
  init_img = loadImage("Before elections 015.JPG");
  init_img.filter(GRAY);
  init_img.resize(board_size, board_size);
  for (int i = 0; i < board_size; i++)
    for (int j = 0; j < board_size; j++) {
      println(i, j, brightness(init_img.get(i,j))-1); 
    }      
  
  arguments = new HashMap<String, Argument>();
  operations = new HashMap<String, Operation>();
  matrix_elements = new HashMap<String, OpCoef>();
  
  new OpWhite();
  new OpBlack();
  
  // create constants out of the image
  for (int i = 0; i < board_size; i++)
    for (int j = 0; j < board_size; j++) {
      new OpConst(brightness(init_img.get(i,j))-1, cell_name(i, j)); 
    }  
  
  // abusing OpWhite as "Const 1" create some weight-controller numbers
  Argument arg_for_weight_from_constants = new Argument("weight from constants");
  Argument arg_for_weight_from_pattern = new Argument("weight from pattern elements");
  arg_for_weight_from_constants.add_new_summand_op("White", 1.0);
  arg_for_weight_from_pattern.add_new_summand_op("White", 0.0);
  
  Argument arg_global_one = new Argument("global one");
  Argument arg_global_control = new Argument("global control");
  Argument arg_global_compliment = new Argument("global compliment");
  Argument arg_global_zero = new Argument("global zero");
  arg_global_one.add_new_summand_op("White", 1.0);
  float global_control_value = 0.0; // CHANGE THIS GRADUALLY: 0.1, 0.2, 0.3 (1.0 is also useful)
  arg_global_control.add_new_summand_op("White", global_control_value);
  arg_global_compliment.add_new_summand_op("White", 1.0-global_control_value);
  // arg_global_zero does not need explicit summands
 
 
  // Board initialization
  for (int i = 0; i < board_size; i++)
    for (int j = 0; j < board_size; j++) {
      String new_arg_name = cell_name(i, j);
      Argument new_arg = new Argument(new_arg_name);
      //new OpId(new_arg, cell_name(i, j));
      /*if ((i%gap_size==0)&&(j%gap_size==0)) {
          create_higher_order_matrix_element(arg_for_weight_from_constants, new_arg, "White");       
      } else {
          create_higher_order_matrix_element(arg_for_weight_from_constants, new_arg, "Black");
      } */
      create_higher_order_matrix_element(arg_for_weight_from_constants, new_arg, "Const "+cell_name(i, j));    
    }

  // Connectivity schema for the current
  // continuous cellular automaton
  // with the influence to the dynamics
  // suppressed by zero coefficients  
  for (int i = 0; i < board_size; i++)
    for (int j = 0; j < board_size; j++)     
      for (int k =0; k < arr_connect.length; k++) {
        int[] pair = coord_modn(i,j, arr_connect[k], board_size);
        int i_cur=pair[0], j_cur=pair[1];
                                   
        String arg_name = "arg " + cell_name(i_cur, j_cur);
        String op_aux_name = "aux " + cell_name(i_cur, j_cur) + " for " + cell_name(i, j);
        String op_sin_name = "sin " + cell_name(i_cur, j_cur) + " for " + cell_name(i, j);
        
        

        new OpRandomizedId(arguments.get(arg_name), arguments.get("arg global control"),
                                              propagation_probability, 
                                              cell_name(i_cur, j_cur) + " for " + cell_name(i, j));
        
        new OpSin(arguments.get(arg_name), arguments.get("arg global compliment"), scale, 
                                              cell_name(i_cur, j_cur) + " for " + cell_name(i, j));
               
        Argument our_arg = arguments.get("arg " + cell_name(i, j));
        create_higher_order_matrix_element(arg_for_weight_from_pattern, our_arg, op_aux_name);
        create_higher_order_matrix_element(arg_for_weight_from_pattern, our_arg, op_sin_name);
      }      
  
}

void draw () {

  // apply template operations
  for (Map.Entry op: operations.entrySet()) {
    ((Operation)op.getValue()).apply(); 
  }
  
  // conditionally adjust matrix weights
  int start_frame_count_range = 10;
  int end_frame_count_range = 11; // change this, for example to 21, for smooth kick-in
  if (frameCount >= start_frame_count_range && frameCount < end_frame_count_range) {
    float delta = 1.0 + frameCount - start_frame_count_range;
    delta = delta / (end_frame_count_range - start_frame_count_range);    
    String matrix_element_name = compute_matrix_element_name("arg weight from constants", "White");
    OpCoef our_op_coef = matrix_elements.get(matrix_element_name); 
    our_op_coef.coef = 1.0 - delta; //0.0;
   
    matrix_element_name = compute_matrix_element_name("arg weight from pattern elements", "White"); 
    our_op_coef = matrix_elements.get(matrix_element_name); 
    our_op_coef.coef = KOEF*delta;
  } 
  
  // apply linear combinations
  for (Map.Entry arg: arguments.entrySet()) {
    ((Argument)arg.getValue()).apply();
  }

 if (frameCount % 2 == 0) { // HACK TO REDUCE FLICKER
  // compute maximal absolute value of a point
  float max_arg_value = 0.0;
  for (int i = 0; i < board_size; i++)
    for (int j = 0; j < board_size; j++) {
      String arg_name = "arg " + cell_name(i, j);
      Argument arg = arguments.get(arg_name);
      float abs_value = abs(arg.value);
      if (max_arg_value < abs_value) max_arg_value = abs_value;
    } 
  
  // render the image
  float strength = 1.0;
  if (max_arg_value > 0 && amplify_brightness) 
    strength = strength/max_arg_value; // "strength" is the brightness amplification
  for (int i = 0; i < board_size; i++)
    for (int j = 0; j < board_size; j++) {
      String arg_name = "arg " + cell_name(i, j);
      Argument arg = arguments.get(arg_name);
      float cell_value = strength * arg.value + 1.0; // +1.0 because of colorMode(RGB, 2.0)
      cell_value = amplify_for_dark*cell_value;
      fill(cell_value, cell_value, cell_value);
      rect(i*square_size, j*square_size, square_size, square_size);
    } 
   
  println(frameCount, strength); 
 }  
  if (frameCount == stopFrame)
    noLoop();
    
  /*for (int i = 0; i < board_size; i++)
    for (int j = 0; j < board_size; j++) {
      float cell_value = brightness(init_img.get(i,j));
      fill(cell_value, cell_value, cell_value);
      rect(i*square_size, j*square_size, square_size, square_size);
    }
  image(init_img,0,0); 
  noLoop();*/
  
  
}

void keyPressed() {
 
  if (key == ' ') noLoop(); 
}

void mousePressed() {

  noLoop();

}

void mouseReleased() {
  
  loop();
}



