public class Blob implements Comparable<Blob>
{
  Dna mDna;
  int mStartX;
  int mStartY;
  float x;
  float y;
  
  int mTargetX;
  int mTargetY;

  int mCurrentGene=0;
  float xDelta;
  float yDelta;
  private boolean mRunning=true;
  int mFitness=0;
  int numGenes=30;

  public String toString()
  {
    return(new String("X:"+x+",Y:"+y+" F:"+mFitness));
  }
  
  public void setTarget(int targetX, int targetY)
  {
    mTargetX=targetX;
    mTargetY=targetY;
  }

  public void stopRunning()
  {
    mRunning=false;
    
    mFitness = fitness(mTargetX, mTargetY);
  }
  
  public boolean isRunning()
  {
    return(mRunning);
  }

  public int fitness(int w, int h)
  {
    int wDelta = Math.abs(w-floor(x));
    int hDelta = Math.abs(h-floor(y));
    int linearDistance;
    int weightedTravelDistance;
    
    // As the crow flies distance remaining to the target (low is better)
    linearDistance = floor(sqrt((wDelta*wDelta)+(hDelta*hDelta)));
    
    // Distance we've actually travelled to get this close, divided
    // by how close we are - gives us some measure of how "effecient"
    // we are (low is better)
    weightedTravelDistance = mDna.mTotalDistance/linearDistance;
    
    // add the 2 together to make overall fitness (low is best).
    //mFitness = linearDistance + weightedTravelDistance;
    mFitness=linearDistance;
    return(mFitness);
  }
  
  // Used for initial population - creates entirely random blob
  public Blob(int sx,int sy)
  {
    mStartX=sx;
    mStartY=sy;
    x = sx;
    y = sy;
    mDna = new Dna(numGenes);
  }

/* Unused - but would clone if necessary
  public Blob(int sx,int sy,Dna d)
  {
    mStartX=sx;
    mStartY=sy;
    x = sx;
    y = sy;
    mDna = new Dna(numGenes,d);
  } */

  // Used for breeding using 2 parents (d1, d2)
  public Blob(int sx,int sy,Dna d1, Dna d2)
  {
    mStartX=sx;
    mStartY=sy;
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
        stopRunning();
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

  public int compareTo(Blob b) {
    // This allows us to sort the array smallest to largest - which means the "best" blobs
    // are at the start of the array, based on a low fitness value being best. 
    // flip the vars around to switch the ordering for a case where largest
    // fitness is best.
    return(mFitness - b.mFitness);
  }
}
