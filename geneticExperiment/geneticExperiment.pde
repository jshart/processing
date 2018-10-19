  
PVector v1, v2;
int w=480;
int h=240;
int numBlobs=15;
Blob blobs[];
int generations=0;
int errorPercent=20;
int breedingSize=5;

void setup() {
  size(480,240);
  //frameRate(10);
  
  blobs = new Blob[numBlobs];
  
  int i;
  for (i=0;i<numBlobs;i++)
  {
    blobs[i] = new Blob();
  }  
}

void draw() {

  int i;

  boolean stillUpdating=true;
  
  stillUpdating=false;
  
  for (i=0;i<numBlobs;i++)
  {
    if (blobs[i].mRunning)
    {
      ellipse(blobs[i].x,blobs[i].y,10,5);
      blobs[i].updatePosition();
      stillUpdating=true;
    }
  }  

  int averageFitness=0;
  int bestFitness=10000;
  
  // Generation has run to completion, update generation
  // ready for next iteration
  if (stillUpdating==false)
  {
    print("Generation run:"+generations++);
    
    BreedingPool bp = new BreedingPool(breedingSize);

    for (i=0;i<numBlobs;i++)
    {
      // Update the final fitness
      averageFitness+=blobs[i].fitness(w,h);
      
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
    
    if (mBlobsInPool < mPoolSize)
    {
      pool[mBlobsInPool]=b;
      mBlobsInPool++;
      if (b.mFitness>mWorseScoreInPool)
      {
        mWorseScoreInPool = b.mFitness; 
      }
    }
    else
    {
      if (b.mFitness<mWorseScoreInPool)
      {
        // Find item to replace as this is better
        // than one of the items in the pool.
        for (i=0;i<mPoolSize;i++)
        {
          if (pool[i].mFitness==mWorseScoreInPool)
          {
            pool[i]=b;
            mWorseScoreInPool = b.mFitness;         
          }
        }
      }
    }
  }
  
  void breed(Blob b[], int ps)
  {
    int i=0;
    int r1, r2;
    
    for (i=0;i<ps;i++)
    {
      r1=floor(random(mPoolSize));
      
      r2=floor(random(mPoolSize));
      
      b[i]=new Blob(pool[r1].mDna,pool[r2].mDna);
    }
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
  
  public Blob()
  {
    x = 0;
    y = 0;
    mDna = new Dna(20);
  }

  public Blob(Dna d)
  {
    x = 0;
    y = 0;
    mDna = new Dna(20,d);
  }

  public Blob(Dna d1, Dna d2)
  {
    x = 0;
    y = 0;
    mDna = new Dna(20, d1, d2);
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
  
  public Gene()
  {
    xDelta = floor(random(50))-25;
    yDelta = floor(random(50))-25;
  }
  
  public Gene(Gene g)
  {
    int r1;
    
    xDelta = g.xDelta;
    yDelta = g.yDelta;

    r1=floor(random(100));    
    if (r1<errorPercent)
    {
      xDelta = floor(random(50))-25;
    }

    r1=floor(random(100));    
    if (r1<errorPercent)
    {
      yDelta = floor(random(50))-25;
    }
  }
}
