int maxW=640;
int maxH=320;

ArrayList<VorCell> vorCells = new ArrayList<VorCell>();

void setup()
{
    size(640,320);
    background(255,255,255);   
    
    int pops=40;
    VorCell v;
    int i;
    
    for (i=0;i<pops;i++)
    {
      //v = new VorCell(floor(random(0,maxW)),floor(random(0,maxH)),color(random(0,255),random(0,255),random(0,255)),color(255,255,255));
      v = new VorCell(floor(random(0,maxW)),floor(random(0,maxH)),color(0,random(150,200),random(150,200)),color(255,255,255));

      vorCells.add(v); 
    }


  stroke(0,125,0);
  //ellipse(125,125,100,100);
  //rect(25,25,100,100);
}

int iterations=0;
void draw()
{
  int s=vorCells.size();
  int i=0;
  iterations++;
  
  for (i=0;i<s;i++)
  {
    vorCells.get(i).populate(iterations);
  }
}

public class VorCell
{ 
  int originX;
  int originY;
  color fc;
  color rc;
  
  ArrayList<Pixel> vPixels = new ArrayList<Pixel>();

  
  public VorCell(int x,int y,color fillC,color replaceC)
  {
    originX=x;
    originY=y;
    fc=fillC;
    rc=replaceC;
      
    Pixel p = new Pixel(originX, originY,fc,0);
    vPixels.add(p);
  }
  
  
  public void populate(int iterations)
  {
    color c;
    if (vPixels.size()==0)
    {
      return;
    }
    
      //print("Q depth:"+pixels.size());
      
      Pixel n = vPixels.get(0);
      vPixels.remove(0);
          
//print("C:"+n.c);

      // Test above
      if (n.y-1>0)
      {
        c = n.checkNeighbour(0,-1);
        if (c==rc)
        {
          vPixels.add(new Pixel(n.x, n.y-1,fc,iterations));
        }
      }
      // Test below
      if (n.y+1<maxH)
      {
        c = n.checkNeighbour(0,+1);
        if (c==rc)
        {
          vPixels.add(new Pixel(n.x, n.y+1,fc,iterations));
        }
      }
      // Test left
      if (n.x-1>0)
      {
        c = n.checkNeighbour(-1,0);
        if (c==rc)
        {
          vPixels.add(new Pixel(n.x-1, n.y,fc,iterations));
        }
      }
      // Test right
      if (n.y+1<maxW)
      {
        c = n.checkNeighbour(+1,0);
        if (c==rc)
        {
          vPixels.add(new Pixel(n.x+1, n.y,fc,iterations));
        }
      }
    
  }
}

public class Pixel
{
  int x;
  int y;
  color c = color(0,125,0);
  
  public Pixel(int px, int py, color fc,int iterations)
  {
    x=px;
    y=py;
    c=fc+iterations;
    draw();
  }
  
  public void draw()
  {
    stroke(c);

    point(x,y);
  }
  
  public int checkNeighbour(int xD, int yD)
  {
    //loadPixels();
    //color nc=get(x+xD, y+yD);
    //print(red(nc)+","+green(nc)+" ");

    return(get(x+xD, y+yD));
    //return(pixels[(y+yD)*maxW+(x+xD)]);
  }
}
