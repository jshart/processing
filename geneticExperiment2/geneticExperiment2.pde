int numObstacles=50;
Block obstacles[];
Block obstacle=new Block();

int breedingSize=6;
Population populations[];
int popSize=6;
Loci cities;

int w=720;
int h=720;
int midW=w/2;
int midH=h/2;
int startX=0;
int startY=midH;


public void setup() {
  size(720, 720);
  background(255,255,255);
  //noStroke(); 
  
  int i;
    
  cities = new Loci(popSize,w,h);
  
  populations = new Population[popSize];
  
  Locus fromCity, toCity;
  
  stroke(255,0,0);
  for (i=0;i<popSize;i++)
  {
    fromCity = cities.mLocus[i];
    toCity = cities.randomLocus(i);
    populations[i]= new Population(30,50,fromCity.mX,fromCity.mY,toCity.mX,toCity.mY); 
    
    line(fromCity.mX,fromCity.mY,toCity.mX,toCity.mY);
  }

  
  obstacles = new Block[numObstacles];
  
  int ox,oy;
  for (i=0;i<numObstacles;i++)
  {
    //obstacles[i] = new Block(w,h);
    
    obstacles[i] = new Block();
    ox=1+(i % 10);
    oy=1+(i / 5);
    
    ox *= 40;
    oy *= 40;
    
    ox+=100;
    oy+=10;
    
    obstacles[i].setPosition(ox,oy);
  }

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
    
    // IF this population has hit the generation limit, bail
    if (populations[k].mCurrentGen>populations[k].mMaxGen)
    {
      break;
    }
    
    fill(255,0,0);
    ellipse(populations[k].mStartX,populations[k].mStartY,10,10);
    
    stroke(populations[k].getCurrentRed(), populations[k].getCurrentGreen(), populations[k].getCurrentBlue());
    //fill(populations[k].mBaseR, populations[k].mBaseG, populations[k].mBaseB);

    populations[k].stillUpdating=false;
    
    // Draw the blobs
    for (i=0;i<numBlobs;i++)
    {
      if (populations[k].mBlobs[i].mRunning)
      {
        //ellipse(blobs[i].x,blobs[i].y,10,5);
        point(populations[k].mBlobs[i].x,populations[k].mBlobs[i].y);
  
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

    // IF this population has hit the generation limit, bail
    if (populations[k].mCurrentGen>populations[k].mMaxGen)
    {
      break;
    }
    
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
