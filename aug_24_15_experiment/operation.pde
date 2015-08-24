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
    name = "id "+_name;
    register();
  }
  
  void apply() {
    result = arg.value; 
  }
}

class OpRandomizedId extends Operation {
  
  Argument arg;
  float propagation_probability;
  
  OpRandomizedId(Argument _arg, float _propagation_probability, String _name) {
    super();
    arg = _arg;
    propagation_probability = _propagation_probability;
    name = "aux "+_name;
    register();
  }
  
  void apply() {
    if (random(1.0) < propagation_probability)
      result = arg.value*1.004;
    else
      result = 0;    
  }
}

