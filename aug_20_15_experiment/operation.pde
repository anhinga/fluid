// Template operatons of fixed arity

class Operation {

  float result;  
  
  Operation () { 
    result = 0.0;   
  }
  
  void apply() {    
  }  
}

class OpWhite extends Operation {

  OpWhite () {
  }
 
  void apply() {
     result = 1.0;
  }
}

class OpBlack extends Operation {

  OpBlack () {
  }
 
  void apply() {
     result = -1.0;
  }
}

class OpId extends Operation {
  
  Argument arg;
  
  OpId(Argument _arg) {
    super();
    arg = _arg;
  }
  
  void apply() {
    result = arg.value; 
  }
}

class OpRandomizedId extends Operation {
  
  Argument arg;
  float propagation_probability;
  
  OpRandomizedId(Argument _arg, float _propagation_probability) {
    super();
    arg = _arg;
    propagation_probability = _propagation_probability;
  }
  
  void apply() {
    if (random(1.0) < propagation_probability)
      result = arg.value;
    else
      result = 0;    
  }
}

