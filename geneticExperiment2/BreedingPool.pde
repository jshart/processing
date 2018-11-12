public class BreedingPool
{
  int mPoolSize=0;
  int mBlobsInPool=0;
  Blob mPool[];
  int mWeights[];
  int mTotalWeight;
  
  public BreedingPool(int poolSize)
  {
    mPool = new Blob[poolSize];
    mWeights = new int[poolSize];
    mPoolSize=poolSize;    
  }
  
  public void add(Blob b)
  {
    // if there is space simply add it
    // as we only get picky once we've
    // got at least a minimum to breed
    // from
    if (mBlobsInPool < mPoolSize)
    {
      mPool[mBlobsInPool]=b;
      mBlobsInPool++;
    }
  }
  
  public void resetPool()
  {
    mBlobsInPool=0;
  }
  
  public int selectWeighted()
  {
    int r = floor(random(mTotalWeight));
    int i;
    int weightWindow=0;
    
    for (i=0;i<mPoolSize;i++)
    {
      weightWindow+=mWeights[i];
      if (r<weightWindow)
      {
        return(i);
      }
    }
    
    // shouldnt get hit - as we should always
    // find a match above, but added to shut
    // up Java warning
    return(i);
  }
  
  
  public void breed(Blob b[], int ps)
  {
    int i=0;
    int r1, r2;
    
    for (i=0;i<ps;i++)
    {
      //r1=floor(random(mPoolSize));
      //r2=floor(random(mPoolSize));
      
      r1=selectWeighted();
      r2=selectWeighted();;
      
      b[i]=new Blob(mPool[r1].mStartX,mPool[r1].mStartY,mPool[r1].mDna,mPool[r2].mDna);
      b[i].setTarget(mPool[r1].mTargetX, mPool[r1].mTargetY);
    }
  }
  
  public String toString()
  {
    String s=new String("TW:"+mTotalWeight+"\n");
    int i;
    for (i=0;i<mPoolSize;i++)
    {
      s+="BPi="+i+" F:"+mPool[i].mFitness+" W:"+mWeights[i]+" TD:"+mPool[i].mDna.mTotalDistance+"\n";
    }
    return(s);
  }
}
