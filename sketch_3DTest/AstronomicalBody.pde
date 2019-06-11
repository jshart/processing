// TODO - I think I need to restructure the core code to generate all the bodies
// without any concept of an orbital radius, and then once the bodies are generated
// go back and create orbital radii based on the number of bodies an orbit needs
// to accomodate.

public class AstronomicalBody
{
  boolean mIsStar=false;
  float mOrbitalRadius;
  float mBodyRadius;
  float mAngle=0;
  float mRotationSpeed;
  BiomeType mBiome;
  ObjectName mName;

  int r,g,b;

  int ssf=1; // System Scale factor (ssf as typed a lot)
  
  AstronomicalBody[] mSatellites;
  
  public AstronomicalBody(ObjectName parentName, int positionInSystem, int scale, boolean star, float orbitalRadius, float mMaxBodyRadius)
  {
    int i;
    mIsStar=star;
    mOrbitalRadius=orbitalRadius;
    mName = new ObjectName(parentName,positionInSystem);
    
    int invScale = 3-scale;
    for (i=0;i<invScale;i++)
    {
      print("\t");
    }
    
    print(mName.mName+" is star? "+star+" OR:"+orbitalRadius+" ");

    if (mIsStar==true)
    {
      mBodyRadius = (random(2.5*ssf)+5*ssf) * scale;
    }
    else
    {
      int range=(int)mMaxBodyRadius/scale;
      mBodyRadius = random(range) * scale;
    }
    
    mBiome = new BiomeType(scale);
    
    mRotationSpeed=random(-0.03,0.03);
 
    // Now lets try and create some satellites if appropriate. If randomly
    // we pick zero, then this body has no satellites and we're done.
    int nSats = (int)(random(3)*scale);
    
    if (nSats<=0 || scale-1<=0)
    {
      // Just new line to close off the rolling print out of the bodies
      // in this part of the system and then return as we're done.
      print("\n");
      return;
    }

    print("Create sats:"+nSats+"\n");
    
    mSatellites = new AstronomicalBody[nSats];
    
    for (i=0;i<nSats;i++)
    {
      float orbitalDistance = ((10*ssf)*scale*(i+1))+mBodyRadius;
      mSatellites[i] = new AstronomicalBody(mName,i,scale-1,false,orbitalDistance, mBodyRadius);  
    }
    print("max orbital distance=="+mSatellites[i-1].mOrbitalRadius);
  }
  
  
  
  public void draw()
  {
    pushMatrix();
    noFill();
    
    if (mIsStar)
    {
      //pointLight(255,255,255,0,0,0);
//      fill(51);
      stroke(255);
    }
    else
    {
      //rotateY(mAngle);
      rotate(mAngle);
      //translate(mOrbitalRadius, 0, 0);
      translate(mOrbitalRadius, 0);

      noStroke();
      
      switch (mBiome.mBiome)
      {
        case BiomeType.BT_FROZEN:
          fill(255,255,255);
          break;
        case BiomeType.BT_DUST:
          fill(255,0,0);
          break;
        case BiomeType.BT_EARTH:
          fill(0,255,0);
          break;
        case BiomeType.BT_MOON:
          fill(100,100,100);
          break;
        default:
          fill(r,g,b);
      }
    }

    //sphere(mBodyRadius);
    ellipse(0,0,mBodyRadius,mBodyRadius);

    if (mSatellites!=null)
    {
      int i=0;
      for (i=0;i<mSatellites.length;i++)
      {
        mSatellites[i].draw();
      }
    }

    popMatrix();
  }

  public void update()
  {
    mAngle+=mRotationSpeed;
    
    if (mSatellites!=null)
    {
      int i=0;
      for (i=0;i<mSatellites.length;i++)
      {
        mSatellites[i].update();
      }
    }
  }
}
