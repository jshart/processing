class Locus
{
  PVector location;
  int mMaxX;
  int mMaxY;
  
  public Locus(int maxX, int maxY)
  {
    mMaxX=maxX;
    mMaxY=maxY;
    
    location = new PVector(random(mMaxX),random(mMaxY));
  }
}
