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

  // frameRate(1);
  
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
  
  (outputs[0]).matrix[0][0] = 1.0; // this is fixed - the main accumulator
  
  // don't touch other (outputs[0]).matrix[0][*] 
  // (and use set_to_plus_constraint0 to maintain this) 
  // use (outputs[0]).matrix[1][*] to change the network matrix
  
  (outputs[0]).matrix[2][0] = 0.5;
  
  (outputs[0]).matrix[4][0] = 0.5;
  (outputs[0]).matrix[5][0] = 0.5;
  
  (outputs[0]).matrix[1][2] = -0.1;
  
  // graphics set-up
  
  int hor_board_size = n_outputs*(max(n_outputs,n_inputs)+1);
  int vert_board_size = 2*n_inputs;
  size(square_size*hor_board_size, square_size*(vert_board_size+1));
  
  background(127);
  noStroke();
  colorMode(RGB, 2.0); // we map color segment [-1,1] ([black:white]) into segment [0,2] 
    
}

void draw() {
  // recompute "inputs"
  for (int i = 0; i < n_inputs; i++) {
    inputs[i].init();
    for (int j = 0; j < n_outputs; j++) {
      inputs[i].add_with_coef((outputs[0]).matrix[i][j], outputs[j]);
    } 
  }
  
  // apply build-in transforms
  outputs[0].set_to_plus_constraint0(inputs[0], inputs[1]);
  outputs[2].set_to_plus(inputs[2], inputs[3]);
  outputs[4].set_to_mult(inputs[4], inputs[5]);
  outputs[6].set_to_mult(inputs[6], inputs[7]);
  outputs[8].set_to_max(inputs[8], inputs[9]);
  outputs[10].set_to_max(inputs[10], inputs[11]);
  
  println(frameCount, (outputs[0]).matrix[0][0]);
  
  // draw all matrices
  
  for (int i = 0; i < n_outputs; i++)
    outputs[i].draw_matrix(i*square_size*(n_outputs+1), 0); // correct version, but without shift
    
  for (int j = 0; j < n_inputs; j++)
    inputs[j].draw_matrix(j*square_size*(n_outputs+1), square_size*(n_inputs+1));
    
   
}
