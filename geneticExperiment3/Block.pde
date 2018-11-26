public class Block
{
  PVector mPosition;
  int mW;
  int mH;
  
  public Block()
  {
    mPosition = new PVector(400,250);
    mW=20;
    mH=20;
  }

  public Block(int x, int y, int w, int h)
  {
    mPosition = new PVector(x,y);
    mW=w;
    mH=h;
  }
  
  public Block(int maxX, int maxY)
  {
    //mY=floor(random(maxY-100))+100;
    mPosition = new PVector(floor(random(maxX-30))+15, floor(random(maxY)));
    mW=20;
    mH=20;
  }
  
  public void setPosition(int x, int y)
  {
    mPosition.set(x,y);
  }

  public boolean contains(PVector p)
  {
    if ((p.x>=mPosition.x && p.x<=(mPosition.x+mW)) && (p.y>=mPosition.y && p.y<=(mPosition.y+mH)))
    {
      return(true);
    }
    return(false);
  }
  
  public boolean contains(int x,int y)
  {
    if ((x>=mPosition.x && x<=(mPosition.x+mW)) && (y>=mPosition.y && y<=(mPosition.y+mH)))
    {
      return(true);
    }
    return(false);
  }
  
  public boolean contains(float x,float y)
  {
    if ((x>=mPosition.x && x<=(mPosition.x+mW)) && (y>=mPosition.y && y<=(mPosition.y+mH)))
    {
      return(true);
    }
    return(false);
  }
}
