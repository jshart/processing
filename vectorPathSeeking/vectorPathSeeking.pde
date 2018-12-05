
int segments=10;
PVector[] path;

MovingObject agent = new MovingObject();

void setup()
{
  size(640, 640);

  createRestrictedRandomWalk2();
  //createRestrictedRandomWalk();  
  printPath();
}

void createRestrictedRandomWalk()
{  
  path = new PVector[segments];
  int mag=30;

  int i;
  for (i=0; i<segments; i++)
  {
    if (i==0)
    {
      path[0]=PVector.random2D();
      path[0].mult(mag);
    }
    else
    {
      path[i]=path[i-1].copy();
      path[i].rotate(random(HALF_PI)-QUARTER_PI);
      //path[i].add(path[i-1]);
    }
    
    //path[i]=new PVector(50*(i+1), 250+(random(200)-100));
  }  
  for (i=1; i<segments; i++)
  {
      path[i].add(path[i-1]);    
  }
}

void createRestrictedRandomWalk2()
{  
  path = new PVector[segments];
  int mag=30;
  
  PVector startingV = PVector.random2D();
  startingV.mult(mag);

  int i;
  float totalRotation=0;
  for (i=0; i<segments; i++)
  {
    path[i]=startingV.copy();
    totalRotation+=random(HALF_PI)-QUARTER_PI;
    path[i].rotate(totalRotation);
  }
  
  for (i=1; i<segments; i++)
  {
      path[i].add(path[i-1]);    
  }
}

void printPath()
{
  int i;
  for (i=0;i<segments;i++)
  {
    printVector(path[i]);
  }
}

void printVector(PVector v)
{
    print("V:"+v+" M:"+v.mag()+"H:"+v.heading());
    println();
}


int seekIndex=0;

void draw()
{
  translate(320,320);

  //PVector mouse = new PVector(mouseX, mouseY);
  agent.seek(path[seekIndex]);

  agent.updatePosition();
  
  int xDelta = abs(floor(agent.mPosition.x) - floor(path[seekIndex].x));
  int yDelta = abs(floor(agent.mPosition.y) - floor(path[seekIndex].y));
  
  if (seekIndex<segments-1 && xDelta<5 && yDelta<5)
  {
     seekIndex++;
     //print("next path seg");
  }
  
  stroke(0, 255, 0);

  ellipse(agent.mPosition.x,agent.mPosition.y,5,5);
  
  int j;
  stroke(255, 0, 0);
  for (j=0; j<segments-1; j++)
  {
    line(path[j].x, path[j].y, path[j+1].x, path[j+1].y);
    ellipse(path[j].x, path[j].y,3,3);
  }
}
