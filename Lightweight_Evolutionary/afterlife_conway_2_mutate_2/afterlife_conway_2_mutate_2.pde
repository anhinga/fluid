// an experiment in pure dataflow matrix machines
//
// "pure" means that the kind of streams of matrices
// defining a dataflow matrix machine is the only
// kind of stream which is used
//
// for this experiment we use finite fixed size network,
// implying finite matrices instead of the theoretically
// prescribed countable-sized matrices.
//
// for this experiment we use plain matrices indexed by
// numbers instead of the theoretically prescribed
// sparse matrices indexed by strings.

int n_outputs = 23;
int n_inputs = 24;

int n_networks = 5;

int square_size = 5;

int seed;

int n_seeds = 10000;

int [] seeds;

int this_generation;

int n_choices;

int [] choices;
int [] frame_moments;

PImage init_img;

int previous_frameCount;

int choice_flag;

Boolean noloop_flag;

int mutation_step_control;

int mutation_step_flag;

class Matrix {
  float [][] matrix;
  Matrix() {
    matrix = new float[n_inputs][n_outputs];
    init();
  } 
  void init() {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) {
        matrix[i][j] = 0.0;
      }
  }
  
  // compute Conway's game of life successor function
  // soft Conway here: -1 alive, 1 dead
  // 2-to-3 alive neigbors is translated as 2-to-4 sum
  // 3 alive neighbords are strictly speaking sum 2
  //
  // let's count the middle -1 as -3 => then for alive we want -1 to 1 overall sum
  //
  // symmetrically, 3+2 = 5, so let's say 4 to 6 overall sum yields alive cell
  //
  // let's use the disjunction of these predicates for now
  
  void pseudoconway(Matrix arg) {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) {
         float sum = 2*arg.matrix[i][j]; // another one will be added in the loop
         for (int i1 = -1; i1 < 2; i1++)
           for (int j1 = -1; j1 < 2; j1++) {
             sum += arg.matrix[(i+i1+n_inputs)%n_inputs][(j+j1+n_outputs)%n_outputs];
           }
         if (((-1 <= sum)&&(sum <= 1)) || ((4 <= sum)&&(sum <= 6))) {
           matrix[i][j] = -1;
         } else {
           matrix[i][j] = 1;
         }         
      } 
  }
  
  
   // poor man sigmoid  - lena  
   void hammer() { 
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) {
        if (abs(matrix[i][j]) > 1)         
          matrix[i][j] = matrix[i][j]/abs(matrix[i][j]);
      }    
  }
  // poor man normalization  - lena  
   void squeeze() { 
    float M=0.;
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) 
        M=max(M,abs(matrix[i][j])); 
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++)         
          matrix[i][j] = matrix[i][j]/M;    
  }
  
  void add_with_coef(float coef, Matrix summand) {
    if (coef != 0.0) {
      for (int i = 0; i < n_inputs; i++)
        for (int j = 0; j < n_outputs; j++) {
          matrix[i][j] += coef*summand.matrix[i][j]; 
        }
    } 
  }
  void set_to_plus_constraint0(Matrix arg1, Matrix arg2) {
    for (int i = 1; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) {
        matrix[i][j] = arg1.matrix[i][j]+arg2.matrix[i][j];
      }
    for (int j = 1; j < n_outputs; j++) {
      matrix[0][j] = 0.0;
    }
    matrix[0][0] = 1.0;  
  }
  void set_to_plus(Matrix arg1, Matrix arg2) {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) {
        matrix[i][j] = arg1.matrix[i][j]+arg2.matrix[i][j];
      } 
  }
  void set_to_mult(Matrix arg1, Matrix arg2) {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) {
        matrix[i][j] = arg1.matrix[i][j]*arg2.matrix[i][j];
      } 
  }
  void set_to_max(Matrix arg1, Matrix arg2) {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) {
        matrix[i][j] = max(arg1.matrix[i][j], arg2.matrix[i][j]);
      } 
  }
  void draw_matrix(int hor_shift, int vert_shift) {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) {
        float cell_value = matrix[i][j] + 1.0;
        fill(cell_value, cell_value, cell_value);
        rect(hor_shift+j*square_size, vert_shift+i*square_size, square_size, square_size);
      } 
  }
}

class Network {
  Matrix[] inputs;
  Matrix[] outputs;
  //Matrix[] initial_outputs;
  //int network_seed;
  Network() {
    inputs = new Matrix[n_inputs];
    outputs = new Matrix[n_outputs];
    //initial_outputs = new Matrix[n_outputs];
    for (int i = 0; i < n_inputs; i++) inputs[i] = new Matrix(); 
    for (int j = 0; j < n_outputs; j++) outputs[j] = new Matrix();
    //for (int j = 0; j < n_outputs; j++) initial_outputs[j] = new Matrix();
    //network_seed = -1;
  }

  /*void get_ready_to_start() {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) 
        for (int k = 0; k < n_outputs; k++) {
          outputs[k].matrix[i][j] = initial_outputs[k].matrix[i][j]; 
        }       
  }*/
  
  void init_from_other_network(int network_index) {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) 
        for (int k = 0; k < n_outputs; k++) {
          outputs[k].matrix[i][j] = networks[network_index].outputs[k].matrix[i][j]; 
        }       
  }

  void init_with_img() {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) 
        for (int k = 0; k < n_outputs; k++) {
          outputs[k].matrix[i][j] = brightness(init_img.get(i,j))-1.0; 
        }       
  }
  
  void init_with_random(int local_seed) {
    randomSeed(local_seed);
    
    // NNN initialize almost averything with random[-1,1]
    for (int i = 0; i < n_inputs; i++) 
      for (int j = 0; j < n_outputs; j++)
        for (int k = 0; k < n_outputs; k++) {
          outputs[k].matrix[i][j] = random(2) - 1.;
        }
    outputs[0].matrix[0][0] = 1.0; // this is fixed - the main accumulator */   
  }
  
  void add_random_noise(int local_seed) {
    randomSeed(local_seed);

    //network_seed = local_seed;

    // NNN initialize almost averything with random[-1,1]
    for (int i = 0; i < n_inputs; i++) 
      for (int j = 0; j < n_outputs; j++) 
         for (int k = 0; k < n_outputs; k++) {
           outputs[k].matrix[i][j] += 0.1*randomGaussian()/mutation_step_control;
         }      
  }
  
  void down_movement() {
    for (int i = 0; i < n_inputs; i++) {
      //inputs[i].hammer(); //NNN
      inputs[i].init();   // strangely enough, we often omit this
      for (int j = 0; j < n_outputs; j++) {
        //outputs[j].hammer();
        inputs[i].add_with_coef((outputs[0]).matrix[i][j], outputs[j]);
      } 
      //inputs[i].hammer(); //NNN
    }  
  }
  
  void up_movement() {
    // apply build-in transforms ("up movement")
    outputs[0].set_to_plus_constraint0(inputs[0], inputs[1]);
    //outputs[0].set_to_plus(inputs[0], inputs[1]);
    outputs[2].pseudoconway(inputs[2]);
    outputs[4].pseudoconway(inputs[4]);
    outputs[6].pseudoconway(inputs[6]);
    outputs[8].pseudoconway(inputs[8]);
    outputs[10].pseudoconway(inputs[10]); 
    //outputs[2].set_to_plus(inputs[2], inputs[3]);
    //outputs[4].set_to_mult(inputs[4], inputs[5]);
    //outputs[6].set_to_mult(inputs[6], inputs[7]);
    //outputs[8].set_to_max(inputs[8], inputs[9]);
    //outputs[10].set_to_max(inputs[10], inputs[11]);
  }
  
  void squeeze_and_draw_network_state(int vert_shift) {
    for (int i = 0; i < n_outputs; i++) {
      //outputs[i].hammer(); //NNN
      outputs[i].squeeze(); //NNN
      (outputs[0]).matrix[0][0]=1.; //NNN
      outputs[i].draw_matrix(i*square_size*(n_outputs+1), vert_shift); // correct version, but without shift
    }
    (outputs[0]).matrix[0][0]=1.; //NNN
    for (int j = 0; j < n_inputs; j++) {
      //inputs[j].hammer(); //NNN
      inputs[j].squeeze(); //NNN
      inputs[j].draw_matrix(j*square_size*(n_outputs+1), vert_shift + square_size*(n_inputs+1));
    }    
  }
}

Network[] networks;

void setup() {
  
  choices = new int[n_seeds]; // too many, really
  frame_moments = new int[n_seeds];
  for (int n = 0; n < n_seeds; n++) {
    choices[n] = 0;
    frame_moments[n] = 0;
  }
  n_choices = 0;
  choice_flag = -1;
  
  noloop_flag = false;
  
  mutation_step_control = 1;
  mutation_step_flag = 0;

  frameRate(2);
  
  previous_frameCount = 0;
  
  seed = int(random(1000000));
  
  //seed = 746484;
  //seed = 300032;
  
  // with image initialization
  
  //seed = 623964;
  //seed = 715221;
  //seed = 915611;
  
  // with random initialization
  
  //seed = 149317;
  
  // for this mutate_2 run
  
  //1743 29328 frameRate 1.9997165 1.0 2.2047155 1.5999374
  //5 choices: ( 4 38 )  ( 2 125 )  ( 0 189 )  ( 0 219 )  ( 3 249 ) 

  //2953 757978 frameRate 1.999785 1.0 1.7866802 1.2663258
  //2 choices: ( 4 135 )  ( 0 201 ) 
  
  randomSeed(seed);
  
  seeds = new int[n_seeds];
  
  for (int n = 0; n < n_seeds; n++) {
    seeds[n] = int(random(1000000));
  }
  
  networks = new Network[n_networks];
  for (int n = 0; n < n_networks; n++) networks[n] = new Network();

  background(127);
  //noStroke();
  colorMode(RGB, 2.0); // we map color segment [-1,1] ([black:white]) into segment [0,2] 
  
  /*init_img = loadImage("Before elections 015.JPG");
  init_img.filter(GRAY);
  //init_img.filter(INVERT);
  init_img.resize(n_inputs, n_outputs);*/
  
  //for (int n = 0; n < n_networks; n++) networks[n].init_with_img();
  networks[0].init_with_random(seeds[0]);
  for (int n = 1; n < n_networks; n++) networks[n].init_from_other_network(0);
  
  this_generation = 1;
  
  //for (int n = 1; n < n_networks; n++) networks[n].add_random_noise(seeds[n + this_generation*n_networks]);
  
  //for (int n = 0; n < n_networks; n++) networks[n].get_ready_to_start();
  
  // don't touch other (outputs[0]).matrix[0][*] 
  // (and use set_to_plus_constraint0 to maintain this) 
  // use (outputs[0]).matrix[1][*] to change the network matrix
  
  
 /* 
  (outputs[0]).matrix[1][1] = 1.0;
  (outputs[1]).matrix[1][1] = -1.0;
  (outputs[1]).matrix[1][3] = 1.0;
  (outputs[3]).matrix[1][3] = -1.0;
  (outputs[3]).matrix[1][5] = 1.0;
  (outputs[5]).matrix[1][5] = -1.0;
  (outputs[5]).matrix[1][7] = 1.0;
  (outputs[7]).matrix[1][7] = -1.0;
  (outputs[7]).matrix[1][9] = 1.0;
  (outputs[9]).matrix[1][9] = -1.0;
  (outputs[9]).matrix[1][1] = 1.0; 
  (outputs[0]).matrix[2][0] = 0.5;
  (outputs[0]).matrix[4][0] = 0.5;
  (outputs[0]).matrix[5][0] = 0.5;  
  */
  
  // graphics set-up
  
  int hor_board_size = n_outputs*(max(n_outputs,n_inputs)+1);
  int vert_board_size = 2*n_inputs+1;
  size(square_size*hor_board_size, square_size*(vert_board_size+4)*n_networks);
  


    
}

void draw() {
  
  if (choice_flag >= 0) next_generation();
  
  if (mutation_step_flag != 0) {
    choices[n_choices] = mutation_step_flag;
    frame_moments[n_choices] = frameCount;
    n_choices += 1;
    if (mutation_step_flag == -1) mutation_step_control *= 2;
    if ((mutation_step_flag == -2) && (mutation_step_control > 1)) mutation_step_control /= 2;
    mutation_step_flag = 0;    
  }
  
  if ( (frameCount-previous_frameCount) == 10) {
    println("adding noise");
    for (int n = 1; n < n_networks; n++) networks[n].add_random_noise(seeds[n + this_generation*n_networks]);
  }

  for (int n = 0; n < n_networks; n++) networks[n].down_movement();  
  
  for (int n = 0; n < n_networks; n++) networks[n].up_movement();  
  
  println(frameCount, seed, "frameRate", frameRate, mutation_step_control, networks[0].outputs[0].matrix[0][0], networks[0].outputs[0].matrix[1][1], networks[0].inputs[1].matrix[1][1]);

  if (n_choices > 0) {  
    print(n_choices, "choices:");
    for (int n = 0; n < n_choices; n++) print(" (", choices[n], frame_moments[n], ") ");
    println();
  }
  
  // draw all matrices
  
  for (int n = 0; n < n_networks; n++) networks[n].squeeze_and_draw_network_state(2*n*(square_size*(n_inputs+1)+2*square_size));

}

void next_generation() {
  
  networks[0].init_from_other_network(choice_flag);
  
  for (int n = 1; n < n_networks; n++) networks[n].init_from_other_network(0);
  
  this_generation += 1;
  
  //for (int n = 1; n < n_networks; n++) networks[n].add_random_noise(seeds[n + this_generation*n_networks]);
  
  //for (int n = 1; n < n_networks; n++) networks[n].get_ready_to_start();
  
  choices[n_choices] = choice_flag;
  frame_moments[n_choices] = frameCount;
  n_choices += 1; 
  
  choice_flag = -1;
 
  previous_frameCount = frameCount; 

}

void keyPressed() {
  if (key == '0') choice_flag = 0;
  if (key == '1') choice_flag = 1;
  if (key == '2') choice_flag = 2;
  if (key == '3') choice_flag = 3;
  if (key == '4') choice_flag = 4;
  if (key == ' ') {
    if (noloop_flag) loop(); 
    else noLoop();
    noloop_flag = !noloop_flag;
  }
  if ((key == '-') || (key == '_')) mutation_step_flag = -1;
  if ((key == '+') || (key == '=')) mutation_step_flag = -2;
}
