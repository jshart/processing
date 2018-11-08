class Gene
{
  int xDelta;
  int yDelta;
  
  int mMaxDist=100;
  int errorPercent=5;

  public int randomDist(int d)
  {
    return(floor(random(d))-(d/2));
  }
  
  public Gene()
  {
    xDelta = randomDist(mMaxDist);
    yDelta = randomDist(mMaxDist);
  }
  
  public Gene(Gene g)
  {
    int r1;
    
    xDelta = g.xDelta;
    yDelta = g.yDelta;

    r1=floor(random(100));    
    if (r1<errorPercent)
    {
      xDelta = randomDist(mMaxDist);
      yDelta = randomDist(mMaxDist);
    }
  }
}
