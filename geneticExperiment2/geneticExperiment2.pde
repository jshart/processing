  
int w=640;
int h=480;
int numBlobs=50;
int numObstacles=50;
Block obstacles[];
int generations=0;
int errorPercent=5;
int breedingSize=6;

int midW=w/2;
int midH=h/2;
int startX=0;
int startY=midH;
int targetX=w;
int targetY=midH;

Block obstacle=new Block();

public void setup() {
  size(640, 480);

  //frameRate(10);
  
  blobs = new Blob[numBlobs];
  obstacles = new Block[numObstacles];
  
  int i;
  for (i=0;i<numBlobs;i++)
  {
    blobs[i] = new Blob(startX,startY);
  }  
  
  int ox,oy;
  for (i=0;i<numObstacles;i++)
  {
    obstacles[i] = new Block(w,h);
    
    /*obstacles[i] = new Block();
    ox=1+(i % 10);
    oy=1+(i / 5);
    
    ox *= 40;
    oy *= 40;
    
    ox+=100;
    oy+=10;
    
    obstacles[i].setPosition(ox,oy);*/
  }
  
  background(255,255,255);
  noStroke(); 
}

public void draw() {

  int i,j;

  boolean stillUpdating=false;
  Block tempObstacle;
  
  fill(100, 100, 100);
  // Draw the obstacle
  for (j=0;j<numObstacles;j++)
  {
    tempObstacle = obstacles[j];

    rect(tempObstacle.mX,tempObstacle.mY,tempObstacle.mW,tempObstacle.mH);
  }
   
  fill(250-(generations*5), 250-(generations*5), 250-(generations*5));
  //fill(0, 0, 255-(generations*5));
  
  // Draw the blobs
  for (i=0;i<numBlobs;i++)
  {
    if (blobs[i].mRunning)
    {
      //ellipse(blobs[i].x,blobs[i].y,10,5);
      ellipse(blobs[i].x,blobs[i].y,1,1);

      blobs[i].updatePosition();
        
      for (j=0;j<numObstacles;j++)
      {
        tempObstacle = obstacles[j]; 
        if (tempObstacle.contains(blobs[i].x, blobs[i].y)==true)
        {
          blobs[i].mRunning=false;
          break;
        }
      }
      
      stillUpdating=true;
    }
  }  

  int averageFitness=0;
  int bestFitness=10000;
  
  // Generation has run to completion, update generation
  // ready for next iteration
  if (stillUpdating==false)
  {
    //background(255,255,255);

    print("Generation run:"+generations++);
    print(" Blobs:"+numBlobs);
    
    BreedingPool bp = new BreedingPool(breedingSize);

    for (i=0;i<numBlobs;i++)
    {
      // Update the final fitness
      averageFitness+=blobs[i].fitness(targetX,targetY);
      
      if (blobs[i].mFitness<bestFitness)
      {
        bestFitness = blobs[i].mFitness;
      }
      
      // Add the best blobs to the breedingpool
      bp.add(blobs[i]);
    } 
    print(" bestFitness="+bestFitness);
    print(" averageFitness="+(averageFitness/numBlobs)+"\n");

    bp.breed(blobs, numBlobs);   
  }
}
