// Template operatons of fixed arity

class Operation {

  float result;

  String name;  
  
  Operation () { 
    result = 0.0;   
  }
  
  void apply() {    
  }

  // to call from a constructor of derived class
  void register() {
    operations.put(name, this); // register with the global dictionary of operations
  }  
}

class OpWhite extends Operation {

  OpWhite () {
    name = "White";
    register();
  }
 
  void apply() {
     result = 1.0;
  }
}

class OpBlack extends Operation {

  OpBlack () {
    name = "Black";
    register();
  }
 
  void apply() {
     result = -1.0;
  }
}

class OpId extends Operation {
  
  Argument arg;
  
  OpId(Argument _arg, String _name) {
    super();
    arg = _arg;
    name = "ID "+_name;
    register();
  }
  
  void apply() {
    result = arg.value; 
  }
}

// the OpId for the purpose of higher-order programming
// (this is a bit inartfully expressed for the time being)
class OpHigherOrderId extends Operation {
  
  Argument dependency_arg;
  OpCoef hosted_op_coef;
  
  OpHigherOrderId(Argument _dependency_arg, String target_arg_name, String op_name) {
    super();
    dependency_arg = _dependency_arg;
    name = "id " + compute_matrix_element_name(target_arg_name, op_name);
    Operation op = operations.get(op_name);
    hosted_op_coef = new OpCoef(op, 0.0);
    register();
  }
  
  void apply() {
    result = dependency_arg.value;
    hosted_op_coef.coef = result; 
  }
}

class OpRandomizedId extends Operation {
  
  Argument arg;
  float propagation_probability;
  float stabilizing_adjustment; // to prevent it from converging to zer0
  
  OpRandomizedId(Argument _arg, float _propagation_probability, String _name) {
    super();
    arg = _arg;
    propagation_probability = _propagation_probability;
    stabilizing_adjustment = 1.0 + 0.8*(1.0/propagation_probability - 1.0); 
                                // 0.8 yields adjustment slightly above 1.004 for 0.995 propagation probability
    name = "aux "+_name;
    register();
  }
  
  void apply() {
    if (random(1.0) < propagation_probability)
      result = arg.value*stabilizing_adjustment;
    else
      result = 0;    
  }
}

