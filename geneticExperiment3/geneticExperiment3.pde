import java.util.Arrays;


// geneticExperiment -*-> Population -*-> Blob -1-> Dna -*-> Gene

int numObstacles=0;
int numOfPops=30;
int numOfCities=20;
int blobsPerPop=15;
int maxGens=15;
int w=640;
int h=640;
boolean drawFrameWork=false;
boolean drawCities=true;
boolean drawPerlinNoise=false;
int suppressEarlyGens=0;


Block obstacles[];
Block obstacle=new Block();
Population populations[];
Loci cities;


int midW=w/2;
int midH=h/2;
int startX=0;
int startY=midH;


public void setup() {
  size(640, 640);
  background(255,255,255);
  //noStroke(); 
  
  if (drawPerlinNoise)
  {
    setupPN();
  }
  
  int i;
    
  cities = new Loci(numOfCities,w,h);
  
  populations = new Population[numOfPops];
  
  Locus fromCity, toCity;
  
  stroke(255,0,0);
  for (i=0;i<numOfPops;i++)
  {
    fromCity = cities.randomLocus(i);
    toCity = cities.randomLocus(i);
    populations[i]= new Population(blobsPerPop,maxGens,fromCity.location,toCity.location); 
    
    //populations[i]= new Population(blobsPerPop,maxGens,0,midH,w,midH); 

    if (drawFrameWork)
    {
      line(fromCity.location.x,fromCity.location.y,toCity.location.x,toCity.location.y);
    }
    
    if (drawCities)
    {
      fill(255,0,0);
      ellipse(populations[i].mStart.x,populations[i].mStart.y,10,10);
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

  if (drawPerlinNoise)
  {
    drawPN();
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
    

    if (drawPerlinNoise)
    {
      stroke(125-(125/(populations[k].mCurrentGen+1)),125-(125/(populations[k].mCurrentGen+1)),125-(125/(populations[k].mCurrentGen+1)),populations[k].getCurrentAlphaFixed());
    }
    else
    {
      stroke(populations[k].getCurrentRed(), populations[k].getCurrentGreen(),populations[k].getCurrentBlue(),populations[k].getCurrentAlphaFixed());
    }

    //stroke(populations[k].getCurrentRed(), populations[k].getCurrentGreen(),populations[k].getCurrentBlue());

    //fill(populations[k].mBaseR, populations[k].mBaseG, populations[k].mBaseB);

    populations[k].stillUpdatingPopulation=false;
    
    // Update the blobs positions
    for (i=0;i<numBlobs;i++)
    {
      if (populations[k].mBlobs[i].isRunning())
      {
        //ellipse(blobs[i].x,blobs[i].y,10,5);
        if (populations[k].mCurrentGen>=suppressEarlyGens)
        {
          point(populations[k].mBlobs[i].mMoving.mPosition.x,populations[k].mBlobs[i].mMoving.mPosition.y);
        }
  
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


double cells[][];
int cols=640;
int rows=640;

ImprovedNoise pNoise;


double maxValue=-1;
double minValue=1;
double valueRange=0;
  
void setupPN()
{
  cells=new double[cols][rows];
  pNoise = new ImprovedNoise();

  pNoise();
  
  int i,j;

  
  for (i=0;i<cols;i++)
  {
    for (j=0;j<rows;j++)
    {
      minValue=(cells[i][j]<minValue)?cells[i][j]:minValue;
      maxValue=(cells[i][j]>maxValue)?cells[i][j]:maxValue;
    }
  }
  println("min/max: "+minValue+":"+maxValue);
}

int waterLine=10;
int treeLine=50;
int climateStep=2;
int mountainLine=150;

void drawPN()
{
  int i,j;
  double mappedColour;
  
  valueRange=maxValue-minValue;
  println("valueRange:"+valueRange);
  
  //waterLine=(waterLine<100?waterLine+5:waterLine);
  waterLine=(waterLine>0?waterLine-climateStep:waterLine);
  treeLine=(treeLine<200?treeLine+climateStep:treeLine);

  
  for (i=0;i<cols;i++)
  {
    for (j=0;j<rows;j++)
    {
      mappedColour=(cells[i][j]+Math.abs(minValue))*(255/valueRange);
          
      if (mappedColour<waterLine)
      {
        stroke(0,0,floor((float)mappedColour)+125);
      }
      else if (mappedColour<treeLine)
      {
        stroke(75+floor((float)mappedColour),75+floor((float)mappedColour),0);
      }
      else if(mappedColour<mountainLine)
      {
        stroke(0,255-floor((float)mappedColour),0);
      }
      else
      {
        stroke(floor((float)mappedColour)-150,floor((float)mappedColour)-150,floor((float)mappedColour)-150);
      }
      
      //stroke(0,0,floor((float)mappedColour));
      
      point(i,j);
    }
  }
}
