int w=1280;
int h=640;
VMap map;

public class MapArea {

  int x;
  int y;
  public MapArea(int mx,int my)
  {
    x=mx;
    y=my;
  }
  
  
  public void draw()
  {
    stroke(0,0,0);
    ellipse((float)x,(float)y,10,10);
  }
}

public class VMap {

    MapArea mapAreas[];
  
    public VMap(int divs, int w, int h)
    {
      int x;
      int y;
      int i=0;
      mapAreas = new MapArea[divs];
      
      for (i=0;i<divs;i++)
      {
        x = floor(random(w));
        y = floor(random(h));

        mapAreas[i]=new MapArea(x,y);
      }
    }

    public void draw()
    {

      for (MapArea m: mapAreas)
      {
        m.draw();
      }
    }    
}

void setup() {
  size(1280, 640);
  map = new VMap(10,w,h);
}

void draw() {

  map.draw();
}
