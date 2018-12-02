public class Blob implements Comparable<Blob>
{
  Dna mDna;
  MovingObject mMoving;
  Path mPath;
  
  PVector mFinalTarget;
  PVector mInterimTarget;
  
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

  public void createPathFromDNA()
  {
    int i;

    mPath = new Path(numGenes);

    for (i=0;i<numGenes;i++)
    {
      mPath.addSegment(mDna.mGenes[i].mDelta);
    }
    loadSegment();
    //mInterimTarget = mPath.getNextSegment();
  }
  
  // Used for initial population - creates entirely random blob
  public Blob(PVector p)
  {
    mMoving = new MovingObject(p);
    mDna = new Dna(numGenes);
    createPathFromDNA();
  }

  // Used for breeding using 2 parents (d1, d2)
  public Blob(PVector p,Dna d1, Dna d2)
  {
    mMoving = new MovingObject(p);
    mDna = new Dna(numGenes, d1, d2);
    createPathFromDNA();
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
      // If we're out of segments stop.
      if (mPath.mCurrentSegment==mDna.mGenomeLen-1)
      {
        // reset the segment count to something sane now we're done with this loop
        mPath.mCurrentSegment=0;
        stopRunning();
        
        // Return false to indicate we couldn't update the
        // position (indicating we're done)
        return(false);
      }
      
      // Fetch the next segment
      loadSegment();
      //mInterimTarget = mPath.getNextSegment();
    }

    // Return true to indicate we were we able to update the position.
    return(true);
  }
  
  public void loadSegment()
  {
    mInterimTarget = PVector.add(mMoving.mPosition,mPath.getNextSegment());
    //print("Interim:"+mInterimTarget);
  }

  public int compareTo(Blob b) {
    // This allows us to sort the array smallest to largest - which means the "best" blobs
    // are at the start of the array, based on a low fitness value being best. 
    // flip the vars around to switch the ordering for a case where largest
    // fitness is best.
    return(mFitness - b.mFitness);
  }
}
