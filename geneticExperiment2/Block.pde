public class Block
{
  int mX;
  int mY;
  int mW;
  int mH;
  
  public Block()
  {
    mX=400;
    mY=250;
    mW=20;
    mH=20;
  }

  public Block(int x, int y, int w, int h)
  {
    mX=x;
    mY=y;
    mW=w;
    mH=h;
  }
  
  public Block(int maxX, int maxY)
  {
    mX=floor(random(maxX-30))+15;
    //mY=floor(random(maxY-100))+100;
    mY=floor(random(maxY));
    mW=20;
    mH=20;
  }
  
  public void setPosition(int x, int y)
  {
    mX=x;
    mY=y;
  }
  
  public boolean contains(int x,int y)
  {
    if ((x>=mX && x<=(mX+mW)) && (y>=mY && y<=(mY+mH)))
    {
      return(true);
    }
    return(false);
  }
  
  public boolean contains(float x,float y)
  {
    if ((x>=mX && x<=(mX+mW)) && (y>=mY && y<=(mY+mH)))
    {
      return(true);
    }
    return(false);
  }
}
