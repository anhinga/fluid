// Arguments are computed as sparse linear combinations
// of unlimited arity of the results of template operations

String compute_matrix_element_name(String row_name, String column_name) {
  return "(" + row_name + ")#(" + column_name + ")";
}

class OpCoef {
  Operation op;
  float coef;
 
  OpCoef(Operation _op, float _coef) {
    op = _op;
    coef = _coef;
  } 
}

void create_higher_order_matrix_element(Argument dependency_arg, Argument target_arg, String op_name) {
  OpHigherOrderId for_new_matrix_element = new OpHigherOrderId(dependency_arg, target_arg.name, op_name); 
  target_arg.add_new_higher_order_summand_op(op_name, for_new_matrix_element.hosted_op_coef);
}

// ***** NEED TO ACTUALLY CHECK/CONTROL THE VALUE OF coef_sum ******

class Argument {
  
  float value;
  HashMap<String, OpCoef> linear_combination;
  float coef_sum;
  String name;
  
  Argument(String _name) {
    value = 0.0;
    linear_combination = new HashMap<String, OpCoef>();
    coef_sum = 0.0;
    name = "arg "+_name;
    arguments.put(name, this); // register with the global dictionary of arguments    
  }

  // **************** NEED TO CHECK THAT IT IS NEW *************
  void add_new_summand_op(String op_name, float coef) {
    Operation op = operations.get(op_name);
    String matrix_element_name = compute_matrix_element_name(name, op_name);
    OpCoef new_coef = new OpCoef(op, coef);
    linear_combination.put(matrix_element_name, new_coef);
    matrix_elements.put(matrix_element_name, new_coef);    
  }
  
  // **************** NEED TO CHECK THAT IT IS NEW *************
  void add_new_higher_order_summand_op(String op_name, OpCoef _op_coef) {
    String matrix_element_name = compute_matrix_element_name(name, op_name);
    linear_combination.put(matrix_element_name, _op_coef);
    matrix_elements.put(matrix_element_name, _op_coef);    
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
