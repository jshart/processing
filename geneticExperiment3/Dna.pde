class Dna
{
  Gene[] mGenes;
  int mGenomeLen;
  int mTotalDistance=0;
  
  // Just by calling this constructor we've
  // created n random genes (Each gene
  // constructor generates a random delta
  // position)
  public Dna(int numGenes)
  {
    mGenomeLen=numGenes;
    mGenes = new Gene[numGenes];
  
    int i;
    for (i=0;i<numGenes;i++)
    {
      mGenes[i] = new Gene();
      
      mTotalDistance+=mGenes[i].travelDistance;
    }    
  }

  // This constructor creates a new Dna
  // strand using numGenes from Dna strand d
  public Dna(int numGenes, Dna d)
  {
    mGenomeLen=numGenes;
    mGenes = new Gene[numGenes];
  
    int i;
    for (i=0;i<numGenes;i++)
    {
      mGenes[i] = new Gene(d.mGenes[i]);
      mTotalDistance+=mGenes[i].travelDistance;
    }
  }

  // This constructor creates a new Dna
  // strand using genes randomly from Dna strand d1 and d2
  public Dna(int numGenes, Dna d1, Dna d2)
  {
    mGenomeLen=numGenes;
    mGenes = new Gene[numGenes];
  
    int i;
    int r;
    for (i=0;i<numGenes;i++)
    {
      r=floor(random(2)); 
      if (r==0)
      {
        mGenes[i] = new Gene(d1.mGenes[i]);
      }
      else
      {
        mGenes[i] = new Gene(d2.mGenes[i]);
      }
      mTotalDistance+=mGenes[i].travelDistance;
    }
  }
}
