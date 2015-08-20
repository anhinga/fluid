// Arguments are computed as sparse linear combinations
// of unlimited arity of the results of template operations

class OpCoef {
  Operation op;
  float coef;
 
  OpCoef(Operation _op, float _coef) {
    op = _op;
    coef = _coef;
  } 
}

// ***** NEED TO ACTUALLY CHECK/CONTROL THE VALUE OF coef_sum ******

class Argument {
  
  float value;
  HashMap<String, OpCoef> linear_combination;
  float coef_sum;
  
  Argument() {
    value = 0.0;
    linear_combination = new HashMap<String, OpCoef>();
    coef_sum = 0.0;    
  }

  // **************** NEED TO CHECK THAT IT IS NEW *************
  void add_new_summand_op(String op_name, float coef) {
    Operation op = operations.get(op_name);
    linear_combination.put(op_name, new OpCoef(op, coef));     
  }
  
  // compute value as a linear combination
  void apply() {
    value = 0.0;
    for (Map.Entry opcoef: linear_combination.entrySet()) {
      OpCoef oc = ((OpCoef)opcoef.getValue());
      value += oc.coef * oc.op.result; 
    }    
  }
  
}
