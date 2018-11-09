class Gene
{
  int xDelta;
  int yDelta;
  int travelDistance;
  
  int mMaxDist=100;
  int errorPercent=5;

  public int updateTravelDistance()
  {
    int x=Math.abs(xDelta);
    int y=Math.abs(yDelta);
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
    
    xDelta = g.xDelta;
    yDelta = g.yDelta;
    travelDistance = g.travelDistance;

    r1=floor(random(100));    
    if (r1<errorPercent)
    {
      randomGene();
    }
  }
  
  public void randomGene()
  {
    xDelta = randomDist(mMaxDist);
    yDelta = randomDist(mMaxDist);
    travelDistance=updateTravelDistance();
  }
}
