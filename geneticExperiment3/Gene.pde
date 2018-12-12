class Gene
{
  float travelDistance;
  int mMaxDist=50;
  int errorPercent=10;
  PVector mDelta;
  float mRotation;
  
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
    travelDistance = random(mMaxDist);
    
    mDelta =  PVector.random2D();
    mDelta.setMag(travelDistance);
    mRotation = random(QUARTER_PI)-(QUARTER_PI/2);
  }
}
