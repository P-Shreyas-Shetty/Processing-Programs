/*
  Visualizing Fourier series coefficients using circles.
  Based on code demonstrated in 'Coding Train' Youtube channel
*/
float t = 0;
float dt = 0.01; //timestep
int x0 = 400;
int y0 = 500;
float scale = 200;
float T = 3; //Time period
int N = 100; //Number of harmonics to consider
int cycles = 5;

ArrayList<Float> calcCoeffs(int N, String wave){
  /*
    Function to generate Fourier series coefficients for different waves
  */
  ArrayList<Float> coeffs = new ArrayList<Float>();
  for(int i=0;i<=N;i++){
    switch(wave){
      case "sin" :   
        if(i==1) coeffs.add(1.);
        else coeffs.add(0.);
        break;
        
      case "square":
        if(i%2 != 0) coeffs.add(4/(PI*i));
        else coeffs.add(0.);
        break;
        
      case "sawtooth" :
        if (i!=0){ 
          if (i%2 != 0) coeffs.add(-2/(i*PI));
          else coeffs.add(2/(i*PI));
        }else{
          coeffs.add(0.);
        }
        break;
    }
  }
  return coeffs;
}




ArrayList<Float> coeffs = calcCoeffs(N, "sawtooth");
ArrayList<Float> wave = new ArrayList<Float>();

void setup(){
  size(1600, 1000);
}

void draw(){
  float radius = 0;

  background(0);
  noFill();
  
  float x = x0;
  float y = y0;
  
  //Draw all the circles corresponding to Fourier series coefficients
  //The radius of the circle is derived from Fourier series coefficients
  for(int i=0; i<N; i++){
    
    radius = scale*coeffs.get(i);
    
    //Draws the circle
    stroke(240, 60, 60);
    strokeWeight(1);
    ellipse(x, y, radius*2, radius*2);
    
    //Calculate the centre of next circle
    float xp = x;
    float yp = y;
    x = x + radius*cos(2*PI*i*t/T);
    y = y + radius*sin(2*PI*i*t/T);
    
    //Draw radial line
    stroke(255, 0, 250);
    strokeWeight(2.5);
    line(xp, yp, x, y); 
  }
  
  strokeWeight(5);
  point(x,y);
  
  if(wave.size() < 1000){
    //Conditions make sure that wave ArrayList size is limited to 1000
    wave.add(0, y);
  }else{
    wave.remove(wave.size()-1);
    wave.add(0, y);
  }
  
  int shift = 800;//amount by which wave is shifted right
  
  //Draw the wave
  stroke(0, 255, 0);
  strokeWeight(2);
  beginShape();
  for(int i=0; i<wave.size();i++){
    vertex(i+shift, wave.get(i));
  }
  endShape();
  
  //Draw the line joining wave and circle point
  stroke(200, 255, 0);
  strokeWeight(1);
  line(x, y, shift, y);
  
  t += dt;
  if(t > cycles*T){
    //reset time
    t = 0;
  }
}
