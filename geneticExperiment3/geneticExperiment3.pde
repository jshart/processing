import java.util.Arrays;


// geneticExperiment -*-> Population -*-> Blob -1-> Dna -*-> Gene

int numObstacles=0;
int numOfPops=20;
int blobsPerPop=30;
int maxGens=50;
int w=720;
int h=720;
boolean drawFrameWork=true;

Block obstacles[];
Block obstacle=new Block();
Population populations[];
Loci cities;


int midW=w/2;
int midH=h/2;
int startX=0;
int startY=midH;


public void setup() {
  size(720, 720);
  background(255,255,255);
  //noStroke(); 
  
  int i;
    
  cities = new Loci(numOfPops,w,h);
  
  populations = new Population[numOfPops];
  
  Locus fromCity, toCity;
  
  stroke(255,0,0);
  for (i=0;i<numOfPops;i++)
  {
    fromCity = cities.mLocus[i];
    toCity = cities.randomLocus(i);
    populations[i]= new Population(blobsPerPop,maxGens,fromCity.location,toCity.location); 
    
    //populations[i]= new Population(blobsPerPop,maxGens,0,midH,w,midH); 

    if (drawFrameWork)
    {
      line(fromCity.location.x,fromCity.location.y,toCity.location.x,toCity.location.y);
    }
  }

  obstacles = new Block[numObstacles];
  
  int ox,oy;
  for (i=0;i<numObstacles;i++)
  {
    //obstacles[i] = new Block(w,h);
    
    obstacles[i] = new Block();
    ox=1+(i % 5);
    oy=1+(i / 5);
    
    ox *= 60;
    oy *= 60;
    
    ox+=150;
    oy+=20;
    
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

    rect(tempObstacle.mPosition.x,tempObstacle.mPosition.y,tempObstacle.mW,tempObstacle.mH);
  }
   
  //fill(0, 0, 255-(generations*5));
  
  // First for loop draws/updates each member of each population
  for (k=0;k<numOfPops;k++)
  {
    int numBlobs = populations[k].mMaxPop;

    // IF this population has hit the generation limit, bail
    if (populations[k].mCurrentGen>populations[k].mMaxGen)
    {
      continue;
    }
    
    if (drawFrameWork)
    {
      fill(255,0,0);
      ellipse(populations[k].mStart.x,populations[k].mStart.y,10,10);
    }
    
    stroke(populations[k].getCurrentRed(), populations[k].getCurrentGreen(),populations[k].getCurrentBlue(),populations[k].getCurrentAlpha());
    //fill(populations[k].mBaseR, populations[k].mBaseG, populations[k].mBaseB);

    populations[k].stillUpdatingPopulation=false;
    
    // Draw the blobs
    for (i=0;i<numBlobs;i++)
    {
      if (populations[k].mBlobs[i].isRunning())
      {
        //ellipse(blobs[i].x,blobs[i].y,10,5);
        point(populations[k].mBlobs[i].mMoving.mPosition.x,populations[k].mBlobs[i].mMoving.mPosition.y);
  
        populations[k].mBlobs[i].updatePosition();
          
        for (j=0;j<numObstacles;j++)
        {
          tempObstacle = obstacles[j]; 
          
          if (tempObstacle.contains(populations[k].mBlobs[i].mMoving.mPosition)==true)
          {
            populations[k].mBlobs[i].stopRunning();
            break;
          }
        }
        
        populations[k].stillUpdatingPopulation=true;
      }
    }  
  }
  
  // second for loop checks for any populations that have completed their
  // run (i.e. all members have run to completion) if this is the case
  // we can then breed the populations.
  for (k=0;k<numOfPops;k++)
  {  
    // IF this population has hit the generation limit, bail
    if (populations[k].mCurrentGen>populations[k].mMaxGen)
    {
      continue;
    }
    
    // Generation has run to completion, update generation
    // ready for next iteration
    if (populations[k].stillUpdatingPopulation==false)
    {
      //background(255,255,255);
  
      print("Population:"+k+" Generation run:"+populations[k].mCurrentGen++);
      print(" Blobs:"+populations[k].mMaxPop);
      
      // Sort the current population based on fitness - note this assumes
      // fitness is up to date (recently calculated)
      Arrays.sort(populations[k].mBlobs);
      //print(populations[k]);
      
      // Update the breeding pool with the set of blobs we want to breed from
      populations[k].mBPool.resetPool();
      populations[k].updateBreedingPool();
      print(populations[k].mBPool);

      // breed the blobs to create the new population.
      populations[k].mBPool.breed(populations[k].mBlobs, populations[k].mMaxPop);   
    }
    
    if (drawFrameWork)
    {
      stroke(255,255,255);
      line(populations[k].mStart.x,populations[k].mStart.y,populations[k].mTarget.x,populations[k].mTarget.y);
    }
  }
}
