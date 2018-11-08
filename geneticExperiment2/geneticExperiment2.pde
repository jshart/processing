int numObstacles=50;
Block obstacles[];
Block obstacle=new Block();

int breedingSize=6;
Population populations[];
int popSize=4;

int w=640;
int h=480;
int midW=w/2;
int midH=h/2;
int startX=0;
int startY=midH;


public void setup() {
  size(640, 480);
  int i;
  
  populations = new Population[popSize];
  
  populations[0]= new Population(20,50,0,0,midW,midH);
  populations[0].setBaseColour(255,255,255);
  
  populations[1]= new Population(20,50,640,0,midW,midH);
  populations[1].setBaseColour(255,0,0);

  populations[2]= new Population(20,50,0,480,midW,midH);
  populations[2].setBaseColour(0,255,0);
  
  populations[3]= new Population(20,50,640,480,midW,midH);
  populations[3].setBaseColour(0,0,255);

  
  obstacles = new Block[numObstacles];
  
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

  int i,j,k;

  Block tempObstacle;
  
  fill(100, 100, 100);
  // Draw the obstacle
  for (j=0;j<numObstacles;j++)
  {
    tempObstacle = obstacles[j];

    rect(tempObstacle.mX,tempObstacle.mY,tempObstacle.mW,tempObstacle.mH);
  }
   
  //fill(0, 0, 255-(generations*5));
  
  for (k=0;k<popSize;k++)
  {
    int numBlobs = populations[k].mMaxPop;
    
    fill(populations[k].getCurrentRed(), populations[k].getCurrentGreen(), populations[k].getCurrentBlue());
    //fill(populations[k].mBaseR, populations[k].mBaseG, populations[k].mBaseB);

    populations[k].stillUpdating=false;
    
    // Draw the blobs
    for (i=0;i<numBlobs;i++)
    {
      if (populations[k].mBlobs[i].mRunning)
      {
        //ellipse(blobs[i].x,blobs[i].y,10,5);
        ellipse(populations[k].mBlobs[i].x,populations[k].mBlobs[i].y,1,1);
  
        populations[k].mBlobs[i].updatePosition();
          
        for (j=0;j<numObstacles;j++)
        {
          tempObstacle = obstacles[j]; 
          if (tempObstacle.contains(populations[k].mBlobs[i].x, populations[k].mBlobs[i].y)==true)
          {
            populations[k].mBlobs[i].mRunning=false;
            break;
          }
        }
        
        populations[k].stillUpdating=true;
      }
    }  
  }
  
  
  for (k=0;k<popSize;k++)
  {  
    int averageFitness=0;
    int bestFitness=10000;
    int numBlobs = populations[k].mMaxPop;

    
    // Generation has run to completion, update generation
    // ready for next iteration
    if (populations[k].stillUpdating==false)
    {
      //background(255,255,255);
  
      print("Population:"+k+" Generation run:"+populations[k].mCurrentGen++);
      print(" Blobs:"+numBlobs);
      
      BreedingPool bp = new BreedingPool(breedingSize);
  
      for (i=0;i<numBlobs;i++)
      {
        // Update the final fitness
        averageFitness+=populations[k].mBlobs[i].fitness(populations[k].mTargetX,populations[k].mTargetY);
        
        if (populations[k].mBlobs[i].mFitness<bestFitness)
        {
          bestFitness = populations[k].mBlobs[i].mFitness;
        }
        
        // Add the best blobs to the breedingpool
        bp.add(populations[k].mBlobs[i]);
      } 
      print(" bestFitness="+bestFitness);
      print(" averageFitness="+(averageFitness/numBlobs)+"\n");
  
      bp.breed(populations[k].mBlobs, numBlobs);   
    }
  }
}
