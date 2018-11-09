class Locus
{
  int mX;
  int mY;
  int mMaxX;
  int mMaxY;
  
  public Locus(int maxX, int maxY)
  {
    mMaxX=maxX;
    mMaxY=maxY;
    
    mX = floor(random(mMaxX));
    mY = floor(random(mMaxY));
  }
}
