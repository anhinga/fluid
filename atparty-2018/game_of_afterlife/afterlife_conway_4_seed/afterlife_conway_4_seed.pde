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

int unit_hor_size = 3;
int unit_vert_size = 20;

int vert_space_in_units = 3;

int seed;

float fade, back;

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
  void identity(Matrix arg) {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) {
        matrix[i][j] = arg.matrix[i][j];
      } 
  }
  void negation(Matrix arg) {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) {
        matrix[i][j] = -arg.matrix[i][j];
      } 
  }
  void draw_matrix(int hor_shift, int vert_shift) {
    for (int i = 0; i < n_inputs; i++)
      for (int j = 0; j < n_outputs; j++) {
        float cell_value = matrix[i][j] + 1.0;
        fill(cell_value, cell_value, cell_value);
        rect(hor_shift+j*unit_hor_size, vert_shift+i*unit_vert_size, unit_hor_size, unit_vert_size);
      } 
  }
}

Matrix[] inputs;
Matrix[] outputs;

void setup() {

  frameRate(10);
  
  //seed = int(random(1000000));
  
  //seed = 746484;
  seed = 300032;
  
  randomSeed(seed);
  
  inputs = new Matrix[n_inputs];
  outputs = new Matrix[n_outputs];
  for (int i = 0; i < n_inputs; i++) {
    inputs[i] = new Matrix(); 
  }
  for (int j = 0; j < n_outputs; j++) {
    outputs[j] = new Matrix();
  }
  // define content of n_outputs matrices "outputs"
  // with n_inputs rows and n_outputs columns
  // (note: outputs[0] is the network matrix)
  // 
  // we only need to set non-zero elements
  
  // NNN initialize almost averything with random[-1,1]
  for (int i = 0; i < n_inputs; i++) 
      for (int j = 0; j < n_outputs; j++)
         for (int k = 0; k < n_outputs; k++) {
            (outputs[k]).matrix[i][j] = random(2) - 1.;
  }
  (outputs[0]).matrix[0][0] = 1.0; // this is fixed - the main accumulator
  
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
  
  int hor_board_size = (n_outputs+vert_space_in_units)*max(n_outputs,n_inputs)-vert_space_in_units;
  int vert_board_size = 2*n_inputs;
  size(unit_hor_size*hor_board_size, unit_vert_size*(vert_board_size+1));
  
  background(127);
  //noStroke();
  colorMode(RGB, 2.0); // we map color segment [-1,1] ([black:white]) into segment [0,2] 
    
}

void draw() {
  // recompute "inputs" ("down movement")
  for (int i = 0; i < n_inputs; i++) {
      //inputs[i].hammer(); //NNN
      //inputs[i].init();   //NNN
    for (int j = 0; j < n_outputs; j++) {
      //outputs[j].hammer();
      inputs[i].add_with_coef((outputs[0]).matrix[i][j], outputs[j]);
    } 
    //inputs[i].hammer(); //NNN
  }
  
  // apply build-in transforms ("up movement")
  outputs[0].set_to_plus_constraint0(inputs[0], inputs[1]);
  //outputs[0].set_to_plus(inputs[0], inputs[1]);
  if (frameCount > 50) outputs[2].pseudoconway(inputs[2]);
  if (frameCount > 100) outputs[4].pseudoconway(inputs[4]);
  if (frameCount > 150) outputs[6].pseudoconway(inputs[6]);
  if (frameCount > 200) outputs[8].pseudoconway(inputs[8]);
  if (frameCount > 350) outputs[10].pseudoconway(inputs[10]); 
  if (frameCount > 600) outputs[12].pseudoconway(inputs[12]);
  //if ((frameCount > 700)&&(frameCount <750)) outputs[14].pseudoconway(inputs[14]);
  //outputs[2].set_to_plus(inputs[2], inputs[3]);
  //outputs[4].set_to_mult(inputs[4], inputs[5]);
  //outputs[6].set_to_mult(inputs[6], inputs[7]);
  //outputs[8].set_to_max(inputs[8], inputs[9]);
  if (frameCount > 800) outputs[12].set_to_mult(inputs[12], inputs[13]);
  if (frameCount > 1000) outputs[10].set_to_mult(inputs[10], inputs[11]);
  if (frameCount > 1200) outputs[14].set_to_plus(inputs[14], inputs[15]);
  if (frameCount > 1400) outputs[16].set_to_plus(inputs[16], inputs[17]);
  if (frameCount > 1600) outputs[18].set_to_max(inputs[18], inputs[19]);
  if (frameCount > 1800) outputs[20].set_to_max(inputs[20], inputs[21]);
  if (frameCount > 2000) outputs[20].negation(inputs[20]);//;, inputs[21]);
  if (frameCount > 2200) outputs[18].negation(inputs[18]);

  if (frameCount > 2600) exit();
  
  println(frameCount, seed, width, height, frameRate, (outputs[0]).matrix[0][0], (outputs[0]).matrix[1][1],(inputs[1]).matrix[1][1]);
  
  // draw all matrices
  
  for (int i = 0; i < n_outputs; i++) {
    //outputs[i].hammer(); //NNN
    outputs[i].squeeze(); //NNN
   (outputs[0]).matrix[0][0]=1.; //NNN
    outputs[i].draw_matrix(i*unit_hor_size*(n_outputs+vert_space_in_units), 0); // correct version, but without shift
  }
  (outputs[0]).matrix[0][0]=1.; //NNN
  for (int j = 0; j < n_inputs; j++) {
    //inputs[j].hammer(); //NNN
    inputs[j].squeeze(); //NNN
    inputs[j].draw_matrix(j*unit_hor_size*(n_outputs+vert_space_in_units), unit_vert_size*(n_inputs+1));
  }
  if (frameCount <= 40) {
     textSize(48);
     fade = (40 - frameCount)/40.0;
     back = 1 - fade;
     fill(back*1.0+fade*2.0, back*1.0, back*1.0+fade*2.0);
     text("github.com/anhinga/fluid", 600, 500); 
  }
  if (frameCount >= 2400) {
     textSize(48);
     fade = min((frameCount-2400)/100.0,1.0);
     back = 1 - fade;
     fill(back*1.0+fade*2.0, back*1.0, back*1.0+fade*2.0);
     text("github.com/anhinga/fluid", 600, 500); 
  }
   
}
