class Gene
{
  float travelDistance;
  int mMaxDist=100;
  int errorPercent=5;
  PVector mDelta;
  float mRotation;
  
  public float updateTravelDistance()
  {
    return(mDelta.mag());
  }
  
  public Gene()
  {
    randomGene();
  }
  
  public Gene(Gene g)
  {
    int r1;
    
    mDelta = g.mDelta.copy();
    mRotation = g.mRotation;
    travelDistance = g.travelDistance;

    r1=floor(random(100));    
    if (r1<errorPercent)
    {
      randomGene();
    }
  }
  
  public void randomGene()
  {
    mDelta = PVector.random2D();
    mDelta.mult(random(mMaxDist));
    mRotation = random(HALF_PI)-QUARTER_PI;
    
    travelDistance=updateTravelDistance();
  }
}
