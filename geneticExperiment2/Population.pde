class Population
{
  Blob mBlobs[];
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
  boolean stillUpdating=false;
  
  public Population(int maxPop, int maxGen, int startX, int startY, int targetX, int targetY)
  {
    mMaxPop = maxPop;
    mMaxGen = maxGen;
    mStartX = startX;
    mStartY = startY;
    mTargetX = targetX;
    mTargetY = targetY;

    mBlobs = new Blob[mMaxPop];

    int i;
    for (i=0;i<mMaxPop;i++)
    {
      mBlobs[i] = new Blob(mStartX,mStartY);
    }  
  }
  
  public void setBaseColour(int baseR, int baseG, int baseB)
  {
    mBaseR = baseR;
    mBaseG = baseG;
    mBaseB = baseB;
  }
  
  public int getCurrentRed()
  {
    int r;
    if (mBaseR==0)
    {
      return(0);
    }
    
    r=(mBaseR/mMaxGen)*mCurrentGen;
    if (mCurrentGen<45)
    {
      return(255-r);
    }
    else
    {
      return(255);
    }
  }

  public int getCurrentGreen()
  {
    int g;
    if (mBaseG==0)
    {
      return(0);
    }
    
    g=(mBaseG/mMaxGen)*mCurrentGen;
    if (mCurrentGen<45)
    {
      return(255-g);
    }
    else
    {
      return(0);
    }
  }
  
  public int getCurrentBlue()
  {
    int b;
    if (mBaseB==0)
    {
      return(0);
    }    
    
    b=(mBaseB/mMaxGen)*mCurrentGen;
    if (mCurrentGen<45)
    {
      return(255-b);
    }
    else
    {
      return(0);
    }
  }
}
