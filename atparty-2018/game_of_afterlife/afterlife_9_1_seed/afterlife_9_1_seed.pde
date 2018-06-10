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

int n_outputs = 11;
int n_inputs = 12;

int square_size = 10;

int seed;

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

Matrix[] inputs;
Matrix[] outputs;

void setup() {

  frameRate(10);
  
  //seed = int(random(1000000));
  
  seed = 746484;
  
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
      for (int j = 0; j < n_outputs; j++) {
    (outputs[0]).matrix[i][j] = random(2) - 1.;
    (outputs[1]).matrix[i][j] = random(2) - 1.; 
    (outputs[2]).matrix[i][j] = random(2) - 1.; 
   (outputs[3]).matrix[i][j] = random(2) - 1.; 
   (outputs[4]).matrix[i][j] = random(2) - 1.;
   (outputs[8]).matrix[i][j] = random(2) - 1.;
   (outputs[5]).matrix[i][j] = random(2) - 1.;
   (outputs[6]).matrix[i][j] = random(2) - 1.;
   (outputs[9]).matrix[i][j] = random(2) - 1.;
   (outputs[10]).matrix[i][j] = random(2) - 1.;
   (outputs[7]).matrix[i][j] = random(2) - 1.;
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
  
  int hor_board_size = n_outputs*(max(n_outputs,n_inputs)+1);
  int vert_board_size = 2*n_inputs;
  size(square_size*hor_board_size, square_size*(vert_board_size+1));
  
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
  outputs[2].set_to_plus(inputs[2], inputs[3]);
  outputs[4].set_to_mult(inputs[4], inputs[5]);
  outputs[6].set_to_mult(inputs[6], inputs[7]);
  outputs[8].set_to_max(inputs[8], inputs[9]);
  outputs[10].set_to_max(inputs[10], inputs[11]);
  
  println(frameCount, seed, frameRate, (outputs[0]).matrix[0][0], (outputs[0]).matrix[1][1],(inputs[1]).matrix[1][1]);
  
  // draw all matrices
  
  for (int i = 0; i < n_outputs; i++) {
    //outputs[i].hammer(); //NNN
    outputs[i].squeeze(); //NNN
   (outputs[0]).matrix[0][0]=1.; //NNN
    outputs[i].draw_matrix(i*square_size*(n_outputs+1), 0); // correct version, but without shift
  }
  (outputs[0]).matrix[0][0]=1.; //NNN
  for (int j = 0; j < n_inputs; j++) {
    //inputs[j].hammer(); //NNN
    inputs[j].squeeze(); //NNN
    inputs[j].draw_matrix(j*square_size*(n_outputs+1), square_size*(n_inputs+1));
  }
   
}
