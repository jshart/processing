public class Path
{
  PVector[] mSegments;
  int mLastSeg;
  int mMaxSegments;
  int mCurrentSegment;
  
  public Path(int num)
  {
    mSegments = new PVector[num];
    mMaxSegments = num;
    mCurrentSegment = 0;
    mLastSeg = 0;
  }
  
  public void addSegment(PVector p, float rotate)
  {
    if (mLastSeg>=mMaxSegments)
    {
      return;
    }
    
    mSegments[mLastSeg]=p.copy();
    mSegments[mLastSeg].rotate(rotate);
    
    // Make this path segment incremental onto previous (if there is one)
    if (mLastSeg>0)
    {
      mSegments[mLastSeg].add(mSegments[mLastSeg-1]);
    }
    mLastSeg++;
  }
  
  public PVector getNextSegment()
  {
    //print("Next seg;"+mSegments[mCurrentSegment]);
    return(mSegments[mCurrentSegment++]);
  }
}
