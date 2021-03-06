class Population
{
  Blob mBlobs[];
  BreedingPool mBPool;
  int mBreedingSize=6;
  
  int mMaxPop;
  int mMaxGen;
  int mBaseR=255;
  int mBaseG=255;
  int mBaseB=255;
  int mStartX;
  int mStartY;
  int mTargetX;
  int mTargetY;
  int mCurrentGen=0;  
  boolean stillUpdatingPopulation=false;
  
  public String toString()
  {
    int i;
    String s = new String();
    for (i=0;i<mMaxPop;i++)
    {
      s+="B:"+i+mBlobs[i]+"\n";
    }
    return(s);
  }
  
  public Population(int maxPop, int maxGen, int startX, int startY, int targetX, int targetY)
  {
    mMaxPop = maxPop;
    mMaxGen = maxGen;
    mStartX = startX;
    mStartY = startY;
    mTargetX = targetX;
    mTargetY = targetY;
    setColourByStartPosition();

    mBlobs = new Blob[mMaxPop];

    int i;
    for (i=0;i<mMaxPop;i++)
    {
      mBlobs[i] = new Blob(mStartX,mStartY);
      mBlobs[i].setTarget(targetX,targetY);
    }
    
    mBPool = new BreedingPool(mBreedingSize);
  }
    
    
  public void updateBreedingPool()
  {
    int i;
    int totalFitness=0;
    int weight=0;
    int totalWeight=0;

    
    for (i=0;i<mBreedingSize;i++)
    {
      // Update the final fitness
      totalFitness+=mBlobs[i].mFitness;
        
      // Add the best blobs to the breedingpool
      mBPool.add(mBlobs[i]);
    }
    
    print(" BP averageFitness="+(totalFitness/mBPool.mPoolSize)+"\n");
    
    for (i=0;i<mBreedingSize;i++)
    {
      weight = (mBPool.mPool[i].mFitness>0)?totalFitness/mBPool.mPool[i].mFitness:totalFitness;
      mBPool.mWeights[i] = weight;
      totalWeight+=weight;
    }
    mBPool.mTotalWeight = totalWeight;

    
    // The next section of code "tie break" any leading candidates
    // that are the same. The one with the shortest path gets a bonus
    int shortestDistance=100000;
    int shortestDistanceIndex=0;
    boolean favFound=false;
    int bestWeight= mBPool.mWeights[shortestDistanceIndex];
    
    for (i=0;i<mBreedingSize;i++)
    {
      if ((mBPool.mWeights[shortestDistanceIndex] == bestWeight) && (mBPool.mPool[i].mDna.mTotalDistance<shortestDistance))
      {
        shortestDistance=mBPool.mPool[i].mDna.mTotalDistance;
        shortestDistanceIndex=i;
        favFound=true;
      }
    }

 
    // for now 2 is hard-coded, simply as a way to provide some extra probability of reproducing to the best
    // and shortest path
    if (favFound)
    {
      mBPool.mWeights[shortestDistanceIndex]+=2;
      mBPool.mTotalWeight+=2;
    }
  }
  
  // TODO - all this colour code needs ripping out and reworking, the
  // fading-in effect it was attempting to emulate, doesnt really work
  // easily/well - come up with a better way of doing this.
  public void setBaseColour(int baseR, int baseG, int baseB)
  {
    mBaseR = baseR;
    mBaseG = baseG;
    mBaseB = baseB;
  }
  
  public void setColourByStartPosition()
  {
    mBaseR = mStartX % 255;
    mBaseG = ((mStartX+mStartY)/2) % 255;
    mBaseB = mStartY % 255;
  }
  
  public int getCurrentRed()
  {
    return(mBaseR);
  }

  public int getCurrentGreen()
  {
    return(mBaseG);
  }
  
  public int getCurrentBlue()
  {
    return(mBaseB);
  }
  
  public int getCurrentAlpha()
  {
    return(255/mMaxGen);
    //return(40);
  }
}
