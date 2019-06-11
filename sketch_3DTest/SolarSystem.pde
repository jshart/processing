public class SolarSystem
{
  AstronomicalBody mSun;
  ObjectName mName=new ObjectName("FooBar");
  
  public SolarSystem()
  {
    print("Solar System: "+mName.mName+"\n");
    mSun = new AstronomicalBody(mName,0,3,true,0.0,0.0);
  }
  
  public void draw()
  {
    mSun.draw();
  }
  
  public void update()
  {
    mSun.update();
  }
}
