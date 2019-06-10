int w=1280;
int h=640;
VMap map;


public class CellBoard {
  int cells[][];
  int cols;
  int rows;
  
  public CellBoard(int c, int r)
  {
    cols=c;
    rows=r;
    cells = new int[cols][rows];
    return;
  }

  void seedBoard(int seeds)
  { 
    int i,x,y;
    
    for (i=0;i<seeds;i++)
    {
        x = floor(random(cols));
        y = floor(random(rows));
 
        cells[x][y]=floor(random(255));
    }
  }
  
  public void neighbours(int i, int j)
  {
    int a,b;
    int x,y;
    
    for (a=-1;a<2;a++)
    {
       for (b=-1;b<2;b++)
       {
         x = i+a;
         y = j+b;
         
         if (x>=0 && y>=0 && x<cols && y<rows)
         {
           if (cells[x][y]!=0)
           {
             cells[i][j]=cells[x][y];
             return;
           }
         }
       }
    }
  }
}


public class VMap {

    CellBoard cells;
    
    public VMap(int divs, int w, int h)
    {
      cells = new CellBoard(w,h);
 
      cells.seedBoard(divs);
    }

    public void update()
    {
      int i,j;
      
      for (i=0;i<cells.cols;i++)
      {
        for (j=0;j<cells.rows;j++)
        {
           cells.neighbours(i,j);
        }
      }
    }


    public void draw()
    {
      int i,j;
      
      for (i=0;i<cells.cols;i++)
      {
        for (j=0;j<cells.rows;j++)
        {
           stroke(cells.cells[i][j]);
           point(i,j);
        }
      }
    }
}

void setup() {
  size(1280, 640);
  map = new VMap(10,w,h);
}

void draw() {

  map.update();
  map.draw();
}
