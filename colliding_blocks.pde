//program simulating two blocks in a frictionless surface with wall on one side and open on the other side
static float TICK = 1;

Block Block0 = new Block(100, //block0 mass
                         300, //size of block
                         0, //initial velocity
                         500); //initial position
Block Block1 = new Block(1, //block1 mass
                         100, //szie
                         -10,   //initial velocity
                         1000); //initial position
int collision_count = 0; //counter for collision with either wall or between blocks
void setup() {
    size(1500, 500);
    noStroke();
}

void draw() {
  background(51);
  textSize(128);
  text(""+collision_count, 0, 100);
  Block0.checkCollisionAndUpdate(Block1);
  Block0.update();
  Block1.update();
}


class Block {
  //Object representing the blocks
  public float size = 300;
  public float mass = 1;
  public float x_axis = 0;
  public float velocity = 10;
  public float momentum;
  public float kinetic_energy;
  
  public Block(float m, float s, float init_velocity, float init_position) {
    mass = m;
    size = s;
    x_axis = init_position;
    velocity = init_velocity;
    momentum = mass*velocity;
    kinetic_energy = 0.5*mass*velocity*velocity;
  }
  
  public void update() {    
    momentum = mass*velocity;
    kinetic_energy = 0.5*mass*velocity*velocity;
    x_axis = x_axis + TICK*velocity;
    if(x_axis < 0) {
      //check for collision with wall
      collision_count++;
      velocity = -velocity;
      x_axis = 0;
    }
    rect(x_axis, height-size, size, size);
  }
  
  public void checkCollisionAndUpdate(Block other) {
    //collision is when the coordinates of the two blocks overlap
    float x_axis0, x_axis1;
    
    //Chekc which of the block is on the "left"
    if(x_axis < other.x_axis) {
      x_axis0 = x_axis + size;
      x_axis1 = other.x_axis;
    } else {
      x_axis0 = other.x_axis + other.size;
      x_axis1 = x_axis;
    }
    if(x_axis1-x_axis0 <= 0) {
      float velocity_copy = velocity;
      velocity =       (velocity      * (mass - other.mass) + other.velocity* (2*other.mass))/(mass+other.mass);
      other.velocity = (other.velocity* (other.mass - mass) + velocity_copy      * (2*mass)      )/(mass+other.mass);
      collision_count++;
    }
  }
}
