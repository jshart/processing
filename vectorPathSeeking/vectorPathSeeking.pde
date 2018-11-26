
int segments=10;
PVector[] path;

MovingObject agent = new MovingObject();

void setup()
{
  size(640, 640);

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
  agent.seek(path[seekIndex]);

  agent.updatePosition();
  
  int xDelta = abs(floor(agent.mPosition.x) - floor(path[seekIndex].x));
  int yDelta = abs(floor(agent.mPosition.y) - floor(path[seekIndex].y));
  
  if (seekIndex<segments-1 && xDelta<5 && yDelta<5)
  {
     seekIndex++;
     print("next path seg");
  }
  
  stroke(0, 255, 0);

  ellipse(agent.mPosition.x,agent.mPosition.y,5,5);
  
  int j;
  stroke(255, 0, 0);
  for (j=0; j<segments-1; j++)
  {
    line(path[j].x, path[j].y, path[j+1].x, path[j+1].y);
  }
}
