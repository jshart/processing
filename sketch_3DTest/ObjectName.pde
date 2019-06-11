public class ObjectName {
  String mName = new String();
  
  public ObjectName(String nameSeed)
  {
    print(nameSeed+random(100));
    mName=nameSeed+(int)random(100);
  }
  
  public ObjectName(ObjectName nameSeed,int value)
  {
    mName=nameSeed.mName+"-"+value;
  }
}
