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
      
      b[i]=new Blob(pool[r1].mStartX,pool[r1].mStartY,pool[r1].mDna,pool[r2].mDna);
    }
  }
}
