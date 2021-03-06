class Loci
{
  Locus mLocus[];
  int mLocusSize;
  int mMaxX;
  int mMaxY;
  
  public Loci(int maxSize, int maxX, int maxY)
  {
    int i;
    mLocusSize=maxSize;
    mMaxX=maxX;
    mMaxY=maxY;
    
    mLocus = new Locus[mLocusSize];
    for (i=0;i<mLocusSize;i++)
    {
      mLocus[i]=new Locus(mMaxX, mMaxY);
    }
  }
  
  public Locus randomLocus(int exclude)
  {
    int i;
    do
    {
      i = floor(random(mLocusSize));
    } while (i==exclude);
    
    return(mLocus[i]);
  }
}
