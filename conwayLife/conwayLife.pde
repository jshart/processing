int w=1280;
int h=640;
int cellSize=16;
int cols=w/cellSize;
int rows=h/cellSize;

public class CellBoard {
  int cells[][];
  
  public CellBoard(int cols, int rows)
  {
    cells = new int[cols][rows];
    return;
  }

  void seedBoard()
  {
    int i,j;
    
    for (i=1;i<cols-1;i++)
    {
      for (j=1;j<rows+1;j++)
      {
        cells[i][j]=(floor(random(100))<30?1:0);    
      }
    }
  }
  
  public int neighbours(int i, int j)
  {
    int a,b;
    int total=0;
    
    for (a=-1;a<2;a++)
    {
       for (b=-1;b<2;b++)
       {
         total+=cells[i+a][j+b];
       }
    }
    
    // remove focus cell - this saves us dealling with
    // exception in the loops above.
    total-=cells[i][j];
    
    //print(" t:"+total);
    return(total);
  }
}

CellBoard board1;
CellBoard board2;
CellBoard currentBoard;
CellBoard newBoard;
boolean firstBoard;

void flipBoard()
{
  if (firstBoard)
  {
    currentBoard=board2;
    newBoard=board1;
    firstBoard=false;
  }
  else
  {
    currentBoard=board1;
    newBoard=board2;
    firstBoard=true;
  }
}



void setup() {
  size(1280, 640);

  board1 = new CellBoard(1280,640);
  board2 = new CellBoard(1280,640);
  currentBoard=board1;
  newBoard=board2;
  firstBoard=true;
  board1.seedBoard();
}

void draw() {
  
  background(255,255,255);
  updateBoard();
  flipBoard();
  drawBoard();
  //noLoop();
}

void updateBoard()
{
  int i,j;
  int total;
  
  for (i=1;i<cols-1;i++)
  {
    for (j=1;j<rows-1;j++)
    {
      total=currentBoard.neighbours(i,j);
      newBoard.cells[i][j]=0;
            
      // Cell alive rules
      if (currentBoard.cells[i][j]==1)
      {
        if (total<2)
        {
          newBoard.cells[i][j] = 0;        
        }
        
        if (total==2 || total==3)
        {
          newBoard.cells[i][j] = 1;        
        }
        
        if (total>3)
        {
          newBoard.cells[i][j] = 0;  
        }
      }
      else // cell dead rules
      {
        if (total==3)
        {
          newBoard.cells[i][j] = 1;        
        }
        else
        {
          newBoard.cells[i][j] = 0;
        }
      }
    }
  }
}

void drawBoard()
{
  int i,j;
  
  for (i=0;i<cols;i++)
  {
    for (j=0;j<rows;j++)
    {
      if (currentBoard.cells[i][j]==1)
      {
        rect(i*cellSize,j*cellSize,cellSize,cellSize);
      }
    }
  }
}
