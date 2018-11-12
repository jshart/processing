import java.util.Arrays;


// geneticExperiment -*-> Population -*-> Blob -1-> Dna -*-> Gene

int numObstacles=50;
Block obstacles[];
Block obstacle=new Block();

Population populations[];
int numOfPops=8;
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
    
  cities = new Loci(numOfPops,w,h);
  
  populations = new Population[numOfPops];
  
  Locus fromCity, toCity;
  
  stroke(255,0,0);
  for (i=0;i<numOfPops;i++)
  {
    fromCity = cities.mLocus[i];
    toCity = cities.randomLocus(i);
    populations[i]= new Population(30,50,fromCity.mX,fromCity.mY,toCity.mX,toCity.mY); 
    
    //populations[i]= new Population(50,50,0,midH,w,midH); 

    
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
  
  // First for loop draws/updates each member of each population
  for (k=0;k<numOfPops;k++)
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

    populations[k].stillUpdatingPopulation=false;
    
    // Draw the blobs
    for (i=0;i<numBlobs;i++)
    {
      if (populations[k].mBlobs[i].isRunning())
      {
        //ellipse(blobs[i].x,blobs[i].y,10,5);
        point(populations[k].mBlobs[i].x,populations[k].mBlobs[i].y);
  
        populations[k].mBlobs[i].updatePosition();
          
        for (j=0;j<numObstacles;j++)
        {
          tempObstacle = obstacles[j]; 
          
          if (tempObstacle.contains(populations[k].mBlobs[i].x, populations[k].mBlobs[i].y)==true)
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
      break;
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
  }
}
