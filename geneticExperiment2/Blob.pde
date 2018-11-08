public class Blob
{
  Dna mDna;
  float x;
  float y;

  int mCurrentGene=0;
  float xDelta;
  float yDelta;
  boolean mRunning=true;
  int mFitness=0;
  int numGenes=30;

  public String toString()
  {
    return(new String("X:"+x+",Y:"+y));
  }

  public int fitness(int w, int h)
  {
    int wDelta = w-floor(x);
    int hDelta = h-floor(y);
    
    mFitness = floor(sqrt((wDelta*wDelta)+(hDelta*hDelta)));
    return(mFitness);
  }
  
  public Blob(int sx,int sy)
  {
    x = sx;
    y = sy;
    mDna = new Dna(numGenes);
  }

  public Blob(int sx,int sy,Dna d)
  {
    x = sx;
    y = sy;
    mDna = new Dna(numGenes,d);
  }

  public Blob(int sx,int sy,Dna d1, Dna d2)
  {
    x = sx;
    y = sy;
    mDna = new Dna(numGenes, d1, d2);
  }

  
  public void loadGene()
  {
    xDelta=mDna.mGenes[mCurrentGene].xDelta;
    yDelta=mDna.mGenes[mCurrentGene].yDelta;
  }
  
  public boolean updatePosition()
  {
    // TODO - we need to come back and do some edge detection/boucing here
    
    // if we've Consumed this gene, then move onto the next
    if (xDelta==0 && yDelta==0)
    {
      mCurrentGene++;
    
      if (mCurrentGene==mDna.mGenomeLen)
      {
        mCurrentGene=0;
        mRunning=false;
        return(false);
      }
      
      loadGene();
    }
    
    if (xDelta<0)
    {
       xDelta++;
       x--;
    }
    if (xDelta>0)
    {
       xDelta--;
       x++;
    }
    
    if (yDelta<0)
    {
       yDelta++;
       y--;
    }
    if (yDelta>0)
    {
       yDelta--;
       y++;
    }

    return(true);
  }
}
