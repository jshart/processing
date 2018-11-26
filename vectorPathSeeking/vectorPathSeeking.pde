PVector position;
PVector velocity; 
PVector acceleration;
float maxforce = 0.5;
float maxspeed = 4;

int segments=10;
PVector[] path;

void setup()
{
  size(640, 640);

  acceleration = new PVector(0, 0);
  velocity = new PVector(0, -2);
  position = new PVector(0, 180);
  
  
  path = new PVector[segments];

  int i;
  for (i=0; i<segments; i++)
  {
    path[i]=new PVector(50*(i+1), 250+(random(200)-100));
  }
  

  
}

int seekIndex=0;

void draw()
{
  //PVector mouse = new PVector(mouseX, mouseY);
  seek(path[seekIndex]);


  // Update velocity
  velocity.add(acceleration);
  // Limit speed
  velocity.limit(maxspeed);
  position.add(velocity);
  // Reset accelerationelertion to 0 each cycle
  acceleration.mult(0);
  
  int xDelta = abs(floor(position.x) - floor(path[seekIndex].x));
  int yDelta = abs(floor(position.y) - floor(path[seekIndex].y));
  
  if (seekIndex<segments-1 && xDelta<5 && yDelta<5)
  {
     seekIndex++;
     print("next path seg");
  }
  
  stroke(0, 255, 0);

  ellipse(position.x,position.y,5,5);
  
  int j;
  stroke(255, 0, 0);
  for (j=0; j<segments-1; j++)
  {
    line(path[j].x, path[j].y, path[j+1].x, path[j+1].y);
  }
}

void applyForce(PVector force)
{
  acceleration.add(force);
}


void seek(PVector target) 
{
  PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target

//print("seeking:"+target);
  // Scale to maximum speed
  desired.setMag(maxspeed);

  // Steering = Desired minus velocity
  PVector steer = PVector.sub(desired, velocity);
  steer.limit(maxforce);  // Limit to maximum steering force

  applyForce(steer);
}
