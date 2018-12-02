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
  
  public void addSegment(PVector p)
  {
    if (mLastSeg>=mMaxSegments)
    {
      return;
    }
    
    mSegments[mLastSeg]=p.copy();
    mLastSeg++;
  }
  
  public PVector getNextSegment()
  {
    //print("Next seg;"+mSegments[mCurrentSegment]);
    return(mSegments[mCurrentSegment++]);
  }
}
