PVector position;
PVector velocity; 
PVector acceleration;
float maxforce = 0.1;
float maxspeed = 4;

void setup()
{
  size(640, 360);

  acceleration = new PVector(0, 0);
  velocity = new PVector(0, -2);
  position = new PVector(0, 180);
}

void draw()
{
  PVector mouse = new PVector(mouseX, mouseY);
  seek(mouse);


  // Update velocity
  velocity.add(acceleration);
  // Limit speed
  velocity.limit(maxspeed);
  position.add(velocity);
  // Reset accelerationelertion to 0 each cycle
  acceleration.mult(0);
  
  ellipse(position.x,position.y,5,5);
}

void applyForce(PVector force)
{
  acceleration.add(force);
}


void seek(PVector target) 
{
  PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target

  // Scale to maximum speed
  desired.setMag(maxspeed);

  // Steering = Desired minus velocity
  PVector steer = PVector.sub(desired, velocity);
  steer.limit(maxforce);  // Limit to maximum steering force

  applyForce(steer);
}
