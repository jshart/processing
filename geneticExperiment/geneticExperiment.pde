  
int w=640;
int h=480;
int numBlobs=50;
int numObstacles=50;
Blob blobs[];
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

public class BreedingPool
{
  int mWorseScoreInPool=0;
  int mPoolSize=0;
  int mBlobsInPool=0;
  Blob pool[];
  
  public BreedingPool(int poolSize)
  {
    pool = new Blob[poolSize];
    mPoolSize=poolSize;    
  }
  
  public void add(Blob b)
  {
    int i=0;
    
    // if there is space simply add it
    // as we only get picky once we've
    // got at least a minimum to breed
    // from
    if (mBlobsInPool < mPoolSize)
    {
      pool[mBlobsInPool]=b;
      mBlobsInPool++;
      
      // keep a rolling total of worse
      // score in the pool as we'll use
      // this as a measure for what to over
      // write in future
      if (b.mFitness>mWorseScoreInPool)
      {
        mWorseScoreInPool = b.mFitness; 
      }
    }
    else
    {
      // TODO - this is more looping than
      // necessary, but written "simply"
      // for now to aid debugging, come back
      // and clean this up so its more elegant
      
      // we've run out of slots so now
      // start to optimise the pool by
      // replacing worse members with
      // any new ones that are better.
      if (b.mFitness<mWorseScoreInPool)
      {
        // Find item to replace as this is better
        // than one of the items in the pool.
        for (i=0;i<mPoolSize;i++)
        {
          if (pool[i].mFitness==mWorseScoreInPool)
          {
            pool[i]=b;
          }
        }
        
        // ineffecient - but a quick hack for now
        // do a simple linear search now looking
        // for the new worse case. This will tell
        // us what to remove next time around
        mWorseScoreInPool=0;
        for (i=0;i<mPoolSize;i++)
        {
          if (pool[i].mFitness>mWorseScoreInPool)
          {
            mWorseScoreInPool = pool[i].mFitness;    
          }
        }
      }
    }
  }
  
  public void breed(Blob b[], int ps)
  {
    int i=0;
    int r1, r2;
    
    for (i=0;i<ps;i++)
    {
      r1=floor(random(mPoolSize));
      
      r2=floor(random(mPoolSize));
      
      b[i]=new Blob(startX,startY,pool[r1].mDna,pool[r2].mDna);
    }
  }
}

public class Block
{
  int mX;
  int mY;
  int mW;
  int mH;
  
  public Block()
  {
    mX=400;
    mY=250;
    mW=20;
    mH=20;
  }

  public Block(int x, int y, int w, int h)
  {
    mX=x;
    mY=y;
    mW=w;
    mH=h;
  }
  
  public Block(int maxX, int maxY)
  {
    mX=floor(random(maxX-30))+15;
    //mY=floor(random(maxY-100))+100;
    mY=floor(random(maxY));
    mW=20;
    mH=20;
  }
  
  public void setPosition(int x, int y)
  {
    mX=x;
    mY=y;
  }
  
  public boolean contains(int x,int y)
  {
    if ((x>=mX && x<=(mX+mW)) && (y>=mY && y<=(mY+mH)))
    {
      return(true);
    }
    return(false);
  }
  
  public boolean contains(float x,float y)
  {
    if ((x>=mX && x<=(mX+mW)) && (y>=mY && y<=(mY+mH)))
    {
      return(true);
    }
    return(false);
  }
}

public class Blob
{
  Dna mDna;
  float x;
  float y;

  int mCurrentGene=0;
  float xDelta;
  float yDelta;
  boolean mRunning=true;
  int mFitness=0;
  int numGenes=30;

  public String toString()
  {
    return(new String("X:"+x+",Y:"+y));
  }

  public int fitness(int w, int h)
  {
    int wDelta = w-floor(x);
    int hDelta = h-floor(y);
    
    mFitness = floor(sqrt((wDelta*wDelta)+(hDelta*hDelta)));
    return(mFitness);
  }
  
  public Blob(int sx,int sy)
  {
    x = sx;
    y = sy;
    mDna = new Dna(numGenes);
  }

  public Blob(int sx,int sy,Dna d)
  {
    x = sx;
    y = sy;
    mDna = new Dna(numGenes,d);
  }

  public Blob(int sx,int sy,Dna d1, Dna d2)
  {
    x = sx;
    y = sy;
    mDna = new Dna(numGenes, d1, d2);
  }

  
  public void loadGene()
  {
    xDelta=mDna.mGenes[mCurrentGene].xDelta;
    yDelta=mDna.mGenes[mCurrentGene].yDelta;
  }
  
  public boolean updatePosition()
  {
    // TODO - we need to come back and do some edge detection/boucing here
    
    // if we've Consumed this gene, then move onto the next
    if (xDelta==0 && yDelta==0)
    {
      mCurrentGene++;
    
      if (mCurrentGene==mDna.mGenomeLen)
      {
        mCurrentGene=0;
        mRunning=false;
        return(false);
      }
      
      loadGene();
    }
    
    if (xDelta<0)
    {
       xDelta++;
       x--;
    }
    if (xDelta>0)
    {
       xDelta--;
       x++;
    }
    
    if (yDelta<0)
    {
       yDelta++;
       y--;
    }
    if (yDelta>0)
    {
       yDelta--;
       y++;
    }

    return(true);
  }
}


class Dna
{
  Gene[] mGenes;
  int mGenomeLen;
  
  // Just by calling this constructor we've
  // created n random genes (Each gene
  // constructor generates a random delta
  // position)
  public Dna(int numGenes)
  {
    mGenomeLen=numGenes;
    mGenes = new Gene[numGenes];
  
    int i;
    for (i=0;i<numGenes;i++)
    {
      mGenes[i] = new Gene();
    }    
  }

  // This constructor creates a new Dna
  // strand using numGenes from Dna strand d
  public Dna(int numGenes, Dna d)
  {
    mGenomeLen=numGenes;
    mGenes = new Gene[numGenes];
  
    int i;
    for (i=0;i<numGenes;i++)
    {
      mGenes[i] = new Gene(d.mGenes[i]);
    }
  }

  // This constructor creates a new Dna
  // strand using genes randomly from Dna strand d1 and d2
  public Dna(int numGenes, Dna d1, Dna d2)
  {
    mGenomeLen=numGenes;
    mGenes = new Gene[numGenes];
  
    int i;
    int r;
    for (i=0;i<numGenes;i++)
    {
      r=floor(random(2)); 
      if (r==0)
      {
        mGenes[i] = new Gene(d1.mGenes[i]);
      }
      else
      {
        mGenes[i] = new Gene(d2.mGenes[i]);
      }
    }
  }
}

class Gene
{
  int xDelta;
  int yDelta;
  
  int mMaxDist=100;
  
  public int randomDist(int d)
  {
    return(floor(random(d))-(d/2));
  }
  
  public Gene()
  {
    xDelta = randomDist(mMaxDist);
    yDelta = randomDist(mMaxDist);
  }
  
  public Gene(Gene g)
  {
    int r1;
    
    xDelta = g.xDelta;
    yDelta = g.yDelta;

    r1=floor(random(100));    
    if (r1<errorPercent)
    {
      xDelta = randomDist(mMaxDist);
      yDelta = randomDist(mMaxDist);
    }
  }
}
