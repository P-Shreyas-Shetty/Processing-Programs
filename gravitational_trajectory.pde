/*
  Author: P Shreyas Shetty
  Draws the trajectory of a satellite around a planet.
  The position is found by system of ODE's obtained from
  Newton's law of universal gravity. The sytem of ODEs in Vector form is
    R'' = GM*R/r^3
      where R = (x, y, z)
            r = |R| = sqrt(x^2 + y^2 + z^2)
    The equation is solved for initial conditions, R0(x0, y0, z0)
    and V0(vx0, vy0, vz0) where R0 is initial position and V0 is initial
    velocity.
    For the sake of simplicity, we set G = 1
   
   The equation is then solved using the finite difference method

*/

//Initial Conditions
//Initial position
float x0 = 200;
float y0 = 200;
float z0 = 200;
//Initial velocity
float vx0 = -12;
float vy0 = -22;
float vz0 = 12;

//Parameters
float d = 3.4; //Number of dimensions
//Change the number of dimensions(even fractional) to see the behaviour
//of gravitational force in different dimensionality. It's fun!
//Observations:
//At 3<d<4, there are stable orbits but they are not elliptical, but rather complex flower like pattern
//for d>=4, it seems like there are there is no stable orbits

float M = 3e6; //Mass of the planet
float planet_radius = 80; //Radius of the planet, obviously

//Simulation parameter;
float dt = 0.1; //Time step

//Values
ArrayList<float[]> R = new ArrayList<float[]>(); //For holding the coordinates
float r; //For storing the distance of satellite from the planet's center
float xn, yn, zn; 

//Simulation step
int n = 1;

void setup(){
  size(2000, 1000, P3D);
  colorMode(HSB);
  R.add(new float[]{x0, y0, z0}); //Set the initial condition
  //Find the next position from the initial velocity
  R.add(new float[]{0, 0, 0});
  R.get(n)[0] = vx0*dt + x0;
  R.get(n)[1] = vy0*dt + y0;
  R.get(n)[2] = vz0*dt + z0;
  n++; //Increment step
}


void draw(){
  //Calculate the distance of satellite from the planet
  r = sqrt(R.get(n-1)[0]*R.get(n-1)[0] +
           R.get(n-1)[1]*R.get(n-1)[1] +
           R.get(n-1)[2]*R.get(n-1)[2]);
           
  if(r<=planet_radius){
    //If satellite hits the planet, stop the simulation
    return;
  }
  
  //Calculate the next position(using finite difference method)
  xn = (-dt*dt*M/pow(r, d) + 2)*R.get(n-1)[0] - R.get(n-2)[0];
  yn = (-dt*dt*M/pow(r, d) + 2)*R.get(n-1)[1] - R.get(n-2)[1];
  zn = (-dt*dt*M/pow(r, d) + 2)*R.get(n-1)[2] - R.get(n-2)[2];
  
  //Add the next position to list of points
  R.add(new float[]{xn, yn, zn});
  
  //Reset the canvas
  background(0);
  
  //Move the coordinate to center of canvas
  translate(width/2, height/2, 0);
  
  //Rotate the canvas slightly in every frame
  
  //Draw the planet
  rotateY(n*PI/600);
  fill(150, 200, 250);
  sphere(planet_radius);
  
  //Draw the trajectory of the satellite
  noFill();
  beginShape();
  for(int i=0;i<n;i++){
    strokeWeight(0.9);
    //Change the stroke slightly every time so that progress is noticable
    stroke(0.1*i%2500, 250, 200);
    vertex(R.get(i)[0],
           R.get(i)[1],
           R.get(i)[2]);
  }
  stroke(100, 200, 300);
  endShape();
  
  //Move the coordinate control to the position of the satellite
  translate(xn,yn,zn);
  //Draw the satellite
  fill(150, 100, 250);
  sphere(10);
  
  //Increment step
  n++;
  
  //Log the position of the satellite
  println(n + " " + xn + " " + yn + " " + zn);
}
