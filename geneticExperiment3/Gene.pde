class Gene
{
  int travelDistance;
  int mMaxDist=100;
  int errorPercent=5;
  PVector mDelta;
  
  public int updateTravelDistance()
  {
    float x=Math.abs(mDelta.x);
    float y=Math.abs(mDelta.y);
    int ans=floor(sqrt((x*x)+(y*y)));
    return(ans);
  }
  
  public int randomDist(int d)
  {
    return(floor(random(d))-(d/2));
  }
  
  public Gene()
  {
    randomGene();
  }
  
  public Gene(Gene g)
  {
    int r1;
    
    mDelta = g.mDelta.copy();
    travelDistance = g.travelDistance;

    r1=floor(random(100));    
    if (r1<errorPercent)
    {
      randomGene();
    }
  }
  
  public void randomGene()
  {
    mDelta = new PVector(randomDist(mMaxDist),randomDist(mMaxDist)); 
    travelDistance=updateTravelDistance();
  }
}
