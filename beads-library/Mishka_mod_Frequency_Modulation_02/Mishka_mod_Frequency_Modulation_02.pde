// Frequency_Modulation_02.pde

import beads.*; // import the beads library
AudioContext ac; // create our AudioContext

// declare our unit generators
WavePlayer modulator;
Glide modulatorFrequency;
WavePlayer carrier;

Gain g;

void setup()
{
  size(1200, 600);

  // initialize our AudioContext
  ac = new AudioContext();
  
  // create the modulator, this WavePlayer will control the frequency of the carrier
  modulatorFrequency = new Glide(ac, 20, 30);
  modulator = new WavePlayer(ac, modulatorFrequency, Buffer.SINE);

  // this is a custom function
  // custom functions are a bit like custom Unit Generators (custom Beads)
  // but they only override the calculate function
  Function frequencyModulation = new Function(modulator)
  {
    public float calculate() {
      // return x[0], which is the original value of the modulator signal (a sine wave)
      // multiplied by 200.0 to make the sine vary between -200 and 200
      // the number 200 here is called the "Modulation Index"
      // the higher the Modulation Index, the louder the sidebands
      // then add mouseY, so that it varies from mouseY - 200 to mouseY + 200
      return (x[0] * 200.0) + mouseY;
    }
  };

  // create a second WavePlayer, control the frequency with the function created above
  carrier = new WavePlayer(ac, frequencyModulation, Buffer.SINE);

  g = new Gain(ac, 1, 0.5); // create a Gain object to make sure we don't peak

  g.addInput(carrier); // connect the carrier to the Gain input
  
  ac.out.addInput(g); // connect the Gain output to the AudioContext
  
  ac.start(); // start audio processing
  
  colorMode(RGB, 2.0);
}

void draw()
{
  background(1.0);
  modulatorFrequency.setValue(mouseX);
  println(frameRate);
  
  float frequencyScale = 60*100.0; // with respect to frameCount (60 is default)
  
  float videoModulatorFrequency = mouseX/frequencyScale;
  float videoModulation = sin(videoModulatorFrequency*frameCount);
  float videoCarrierFrequency = (videoModulation*200.0 + mouseY)/frequencyScale;
  float videoSignal = sin(videoCarrierFrequency*frameCount);
  
  color my_color = color(1.0, videoSignal+1.0, 1.0);
  fill(my_color);
  float rectWidth = (videoSignal+1.0)*width/4;
  float left_X = (width-rectWidth)/2;
  float rectHeight=80;
  float left_Y = (height-rectHeight)/2;
  rect(left_X, left_Y, rectWidth, rectHeight);
  
  float circle_Y = height/2 - videoSignal*height/4;
  ellipse(width/8, circle_Y, 80, 80);
  ellipse(width  - width/8, circle_Y, 80, 80);
  
  
  
}
