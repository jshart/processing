public class BiomeType
{
  static final int BT_START_PLANET=1;
  static final int BT_FROZEN=1;
  static final int BT_DUST=2;
  static final int BT_EARTH=3;
  static final int BT_END_PLANET=4;

  static final int BT_START_MOON=100;
  static final int BT_MOON=100;
  static final int BT_END_MOON=200;
  
  static final int BT_STAR=1000;
  
  int mBiome;
  int mDepth;
  
  public BiomeType(int depth)
  {
    mDepth=depth;
    switch (depth)
    {
       case 3:
         mBiome=BT_STAR;
         break;
       case 2:
         mBiome=randomPlanetBiome();
         break;
       case 1:
         mBiome=BT_MOON; // TODO temp - need to add range of types here
         break;
    }
  }
  
  public int randomPlanetBiome()
  {
    return((int)random(BT_START_PLANET,BT_END_PLANET));
  }
}
