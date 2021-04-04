import java.io.File;
import java.io.FileReader;
import java.io.IOException;


String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day11\\data");

ArrayList<String> lines = new ArrayList<String>();
int[][] state1;
int[][] state2;
boolean state1Active=true;
int noLines;
int noCols;
int iteration=0;


//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];


void setup() {
  size(1000, 1000);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));



  try {
    String line;
    
    //File fl = new File(filebase+File.separator+"input2.txt");
    File fl = new File(filebase+File.separator+"input.txt");

    FileReader frd = new FileReader(fl);
    BufferedReader brd = new BufferedReader(frd);
  
    while ((line=brd.readLine())!=null)
    {
      println("loading:"+line);
      
      if (line.length()!=0)
      {
        lines.add(line);
      }
    }
    brd.close();
    frd.close();

  } catch (IOException e) {
     e.printStackTrace();
  }

  noLines=lines.size();
  noCols=lines.get(0).length();
  
  state1=new int[noCols][noLines];
  state2=new int[noCols][noLines];

  
  int i,j;
  char c;
  for (i=0;i<noLines;i++)
  {
    println("IN:"+lines.get(i));
    for (j=0;j<noCols;j++)
    {
      c=lines.get(i).charAt(j);
      if (c=='L')
      {
        state1[j][i]=1;
      }
      else
      {
        state1[j][i]=0;
      }
    }
  }
  
  println("LOADED="+(noCols*noLines)+" cols="+noCols+" lines="+noLines);
}


void draw() {
  int xoffset=32;
  int yoffset=32;
  int x=0,y=0;
  int cellSize=8;
  int currentCell=0;
  int seats=0;
  int people=0;
  
  int maxAcceptableOccupiedSeats=5;
  
  background(0);
  stroke(255); 
  
  for (x=0;x<noCols;x++)
  {
    for (y=0;y<noLines;y++)
    {
      if (state1Active==true)
      {
        currentCell=state1[x][y];
      }
      else
      {
        currentCell=state2[x][y];
      }
      
      if (currentCell>=1)
      {
        stroke(255,0,0);
        fill(255,255,255);
        rect(xoffset+(x*cellSize),yoffset+(y*cellSize),cellSize,cellSize);
        seats++;
      }
      if (currentCell==2)
      {
        stroke(0,244,0);
        fill(0,244,0);
        circle(xoffset+(x*cellSize)+(cellSize/2),yoffset+(y*cellSize)+(cellSize/2),cellSize);
        people++;
      }
    }
  }
  println("stats, seats="+seats+" peoples="+people);
  
  int oSeats=0;
  int stateChanges=0;
  int occupiedSeats=0;
  // Update state
  for (x=0;x<noCols;x++)
  {
    for (y=0;y<noLines;y++)
    {
      
      // Fetch the current cell from the active state matrix
      // check how many adjacent seats are occupied
      if (state1Active==true)
      {
        currentCell=state1[x][y];
        oSeats=countOccupiedSeats2(state1,x,y);
      }
      else
      {
        currentCell=state2[x][y];
        oSeats=countOccupiedSeats2(state2,x,y);
      }
      
      //println("oSeats="+oSeats+" ");
      
      // check the rules
      if (currentCell==1)
      {
        // empty seat - any adjacent seats empty?
        if (oSeats==0)
        {
          // STATE CHANGE
          stateChanges++;
          currentCell=2;
          //println("S2 change");
          occupiedSeats++;
        }
      }
      else if (currentCell==2)
      {
        // occupied seat - any adjacent seats occupied?
        if (oSeats>=maxAcceptableOccupiedSeats)
        {
          // STATE CHANGE
          stateChanges++;
          currentCell=1;
          //println("S1 change");
        }
        else
        {
          occupiedSeats++;
        }
      }
      
      
      // set the new state
      // note - we need to set the*other* state here, so the boolean logic is flipped.
      if (state1Active==false)
      {
        state1[x][y]=currentCell;
      }
      else
      {
        state2[x][y]=currentCell;
      }
    }
  }
  println("iteration="+iteration+" redraw state:"+state1Active+" occupied seats="+occupiedSeats);

  // flip the state we're going to draw...
  state1Active= !state1Active;
  if (stateChanges==0)
  {
    println("Steady state found");
    noLoop();
  }
  //if(iteration==3)
  //{
  //  noLoop();
  //}
  iteration++;
}

//int countOccupiedSeats(int[][] currentState, int x, int y)
//{
//  int occupiedSeats=0;
//  int checkXStart, checkXEnd;
//  int checkYStart, checkYEnd;
//  int xc=0,yc=0;
  
//  // check neighbour seats - safely, considering array edge cases
//  checkXStart=x-1;
//  if (checkXStart<0)
//  {
//    checkXStart=0;
//  }
  
//  checkXEnd=x+1;
//  if (checkXEnd>=noCols)
//  {
//    checkXEnd=noCols-1;
//  }
  
//  checkYStart=y-1;
//  if (checkYStart<0)
//  {
//    checkYStart=0;
//  }
  
//  checkYEnd=y+1;
//  if (checkYEnd>=noLines)
//  {
//    checkYEnd=noLines-1;
//  }

//  int seatschecked=0;

//  for (xc=checkXStart;xc<=checkXEnd;xc++)
//  {
//    for (yc=checkYStart;yc<=checkYEnd;yc++)
//    {
//      //print(xc+","+yc+" ");
//      seatschecked++;
//      if (xc==x && yc==y)
//      {
//        // skip the cell itself
//      }
//      else
//      {
//        // check if neighbours are full or not
//        if (currentState[xc][yc]==2)
//        {
//          occupiedSeats++;
//        }
//      }
//    }
//  }
//  //print("Seats checked="+seatschecked+" ");
//  return(occupiedSeats);
//}

int countOccupiedSeats2(int[][] currentState, int x, int y)
{
  int occupiedSeats=0;

  int xc,yc;
  
  // *** CARDINALs
  
   //check Left;
   xc=x-1;
   yc=y;
   while(xc>=0)
   {
     //print("<");
     if (currentState[xc][yc]>0)
     {
       if (currentState[xc][yc]==2)
       {
         occupiedSeats++;
       }
       break;
     }
     xc--;
   }

   // check up
   xc=x;
   yc=y-1;
   while(yc>=0)
   {
     //print("^");
     if (currentState[xc][yc]>0)
     {
       if (currentState[xc][yc]==2)
       {
         occupiedSeats++;
       }
       break;
     }
     yc--;
   }
 
   //check Right;
   xc=x+1;
   yc=y;
   while(xc<noCols)
   {
     //print(">");

     if (currentState[xc][yc]>0)
     {
       if (currentState[xc][yc]==2)
       {
         occupiedSeats++;
       }
       break;
     }
     xc++;
   }

   // check down
   xc=x;
   yc=y+1;
   while(yc<noLines)
   {
     //print("v");
     if (currentState[xc][yc]>0)
     {
       if (currentState[xc][yc]==2)
       {
         occupiedSeats++;
       }  
       break;
     }
     yc++;
   }
   
   
   
   // *** CHECK DIAGONALS
   
   //check Left & up;
   xc=x-1;
   yc=y-1;
   while(xc>=0 && yc>=0)
   {
     //print("\\");
     if (currentState[xc][yc]>0)
     {
       if (currentState[xc][yc]==2)
       {
         occupiedSeats++;
       }
       break;
     }
     xc--;
     yc--;
   }

   // check right & up
   xc=x+1;
   yc=y-1;
   while(xc<noCols && yc>=0)
   {
     //print("/");
     if (currentState[xc][yc]>0)
     {
       if (currentState[xc][yc]==2)
       {
         occupiedSeats++;
       }
       break;
     }
     xc++;
     yc--;
   }
 
   //check Right & down;
   xc=x+1;
   yc=y+1;
   while(xc<noCols && yc<noLines)
   {
     //print("/");
     if (currentState[xc][yc]>0)
     {
       if (currentState[xc][yc]==2)
       {
         occupiedSeats++;
       }
       break;
     }
     yc++;
     xc++;
   }

   // check Left & down
   xc=x-1;
   yc=y+1;
   while(xc>=0 && yc<noLines)
   {
     //print("\\");
     if (currentState[xc][yc]>0)
     {
       if (currentState[xc][yc]==2)
       {
         occupiedSeats++;
       }
       break;
     }
     xc--;
     yc++;
   }
 
 
  return(occupiedSeats);
}
