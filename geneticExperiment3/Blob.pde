public class Blob implements Comparable<Blob>
{
  Dna mDna;
  MovingObject mMoving;
  
  PVector mFinalTarget;
  PVector mInterimTarget;
  
  int mCurrentGene=0;
  private boolean mRunning=true;
  int mFitness=0;
  int numGenes=20;

  public String toString()
  {
    return(new String("X:"+mMoving.mPosition.x+",Y:"+mMoving.mPosition.y+" F:"+mFitness));
  }
  
  public void setTarget(int targetX, int targetY)
  {
    mFinalTarget = new PVector(targetX,targetY);
  }

  public void setTarget(PVector target)
  {
    mFinalTarget = target.copy();
  }


  public void stopRunning()
  {
    mRunning=false;
    
    mFitness = fitness();
  }
  
  public boolean isRunning()
  {
    return(mRunning);
  }

  public int fitness()
  {
    return(fitness(mFinalTarget));
  }
  
  public int fitness(PVector t)
  {
    return(fitness(t.x, t.y));
  }

  public int fitness(float x, float y)
  {
    int wDelta = floor(abs(x-floor(mMoving.mPosition.x)));
    int hDelta = floor(abs(y-floor(mMoving.mPosition.y)));
    int linearDistance;
    
    // As the crow flies distance remaining to the target (low is better)
    linearDistance = floor(sqrt((wDelta*wDelta)+(hDelta*hDelta)));
    
    mFitness=linearDistance;
    return(mFitness);
  }
  
  // Used for initial population - creates entirely random blob
  public Blob(PVector p)
  {
    mMoving = new MovingObject(p);
    mDna = new Dna(numGenes);
    loadGene();
  }


  // Used for initial population - creates entirely random blob
  public Blob(int sx,int sy)
  {
    mMoving = new MovingObject(sx,sy);
    mDna = new Dna(numGenes);
    loadGene();
  }

/* Unused - but would clone if necessary
  public Blob(int sx,int sy,Dna d)
  {
    mMoving = new MovingObject(sx,sy);
    mDna = new Dna(numGenes,d);
    loadGene();
  } */

  // Used for breeding using 2 parents (d1, d2)
  public Blob(PVector p,Dna d1, Dna d2)
  {
    mMoving = new MovingObject(p);
    mDna = new Dna(numGenes, d1, d2);
    loadGene();
  }

  
  // Used for breeding using 2 parents (d1, d2)
  public Blob(int sx,int sy,Dna d1, Dna d2)
  {
    mMoving = new MovingObject(sx,sy);
    mDna = new Dna(numGenes, d1, d2);
    loadGene();
  }

  
  public void loadGene()
  {
    mInterimTarget = PVector.add(mMoving.mPosition,mDna.mGenes[mCurrentGene].mDelta);
    //print("Interim:"+mInterimTarget);
  }
  
  public boolean updatePosition()
  {
    PVector delta;
    
    mMoving.updatePosition();
    mMoving.seek(mInterimTarget);
    
    delta = PVector.sub(mMoving.mPosition, mInterimTarget);
    
    // TODO - we need to come back and do some edge detection/boucing here
    
    // if we've Consumed this gene, then move onto the next
    if (delta.x<5 && delta.y<5)
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
