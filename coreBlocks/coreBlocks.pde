import uibooster.*;
import uibooster.model.*;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;

FilledForm form;

//String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day17\\data");

ArrayList<String> lines = new ArrayList<String>();
int[][][] state1;
int[][][] state2;
boolean state1Active=true;
int yd=50;
int xd=50;
int zd=50;
int iteration=0;


//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];


void mouseClicked() {
  new UiBooster().showInfoDialog("UiBooster is a lean library to ....");

}


void setup() {
  size(1000, 1000,P3D);
  //size(1000, 1000);

  background(0);
  stroke(255);
  frameRate(1);

  stroke(255);
  frameRate(30);
  
  //new UiBooster().showInfoDialog("UiBooster is a lean library to ....");

  //UiBooster booster = new UiBooster();
  //form = booster.createForm("Personal information")
  //            .addText("Whats your first name?")
  //            .addTextArea("Tell me something about you")
  //            .addLabel("Choose an action")
  //            .addSlider("How many liters did you drink today?", 0, 5, 1, 5, 1)
  //            .show();


  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  
  state1=new int[xd][yd][zd];
  state2=new int[xd][yd][zd];

  
  int i,j;
  char c;
  int xo=xd/2;
  int yo=yd/2;
  int zo=zd/2;
  for (i=0;i<20;i++)
  {
    for (j=0;j<20;j++)
    {
      //c=lines.get(i).charAt(j);
      if (random(1)>0)
      {
        state1[j+xo][i+yo][zo]=1;
      }
      else
      {
        state1[j+xo][i+yo][zo]=0;
      }
    }
  }
  
  println("LOADED="+(xd*yd)+" cols="+xd+" lines="+yd);
}


void draw() {
  int xoffset=500;
  int yoffset=500;
  int x=0,y=0,z=0;
  int cellSize=4;
  int currentCell=0;
  int seats=0;
  int people=0;
  
  rotateX(PI/4);
  
  background(0);
  stroke(255); 
  
  new UiBooster().showInfoDialog("UiBooster is a lean library to ...."); 

  for (y=0;y<yd;y++)
  {
    for (x=0;x<xd;x++)
    {
      for (z=0;z<zd;z++)
      {
        if (state1Active==true)
        {
          currentCell=state1[x][y][z];
        }
        else
        {
          currentCell=state2[x][y][z];
        }
        
        if (currentCell>=1)
        {
          stroke(255,0,0);
          fill(50,50,50);
          rect(xoffset+(x*cellSize),yoffset+(y*cellSize),cellSize,cellSize);
          

          stroke(0,0,255);
          fill(0,255,255);
          
          //println("xlate:"+(xoffset+(x*cellSize))+" "+(yoffset+(y*cellSize))+" "+(z*cellSize));

          //translate(xoffset+(x*cellSize),yoffset+(y*cellSize),z*cellSize);
          //box(cellSize,cellSize,cellSize);
          //translate(-(xoffset+(x*cellSize)),-(yoffset+(y*cellSize)),-(z*cellSize));
  
          seats++;
        }
        //if (currentCell==2)
        //{
        //  stroke(0,244,0);
        //  fill(0,244,0);
        //  circle(xoffset+(x*cellSize)+(cellSize/2),yoffset+(y*cellSize)+(cellSize/2),cellSize);
        //  people++;
        //}
      }
    }
  }
  println("stats, seats="+seats+" peoples="+people);
  
  int neighbourCubes=0;
  int stateChanges=0;
  int occupiedCubes=0;
  // Update state
  for (x=0;x<xd;x++)
  {
    for (y=0;y<yd;y++)
    {
      for (z=0;z<zd;z++)
      {
        
        // Fetch the current cell from the active state matrix
        // check how many adjacent seats are occupied
        if (state1Active==true)
        {
          currentCell=state1[x][y][z];
          neighbourCubes=countNearCubes(state1,x,y,z);
        }
        else
        {
          currentCell=state2[x][y][z];
          neighbourCubes=countNearCubes(state2,x,y,z);
        }
        
        //println("oSeats="+oSeats+" ");
        
        // check the rules
        if (currentCell==0)
        {
          // empty seat - any adjacent seats empty?
          if (neighbourCubes==3)
          {
            // STATE CHANGE
            currentCell=1;
            //println("S1 change");
            occupiedCubes++;
            stateChanges++;
          }
        }
        else if (currentCell==1)
        {
          // occupied seat - any adjacent seats occupied?
          if (neighbourCubes==2 || neighbourCubes==3)
          {
            // STATE CHANGE
            currentCell=1;
            occupiedCubes++;
          }
          else
          {
            currentCell=0;
            //println("S0 change");
            stateChanges++;
          }
        }
        
        
        // set the new state
        // note - we need to set the*other* state here, so the boolean logic is flipped.
        if (state1Active==false)
        {
          state1[x][y][z]=currentCell;
        }
        else
        {
          state2[x][y][z]=currentCell;
        }
      }
    }
  }
  println("iteration="+iteration+" redraw state:"+state1Active+" active cubes="+occupiedCubes);

  // flip the state we're going to draw...
  state1Active= !state1Active;
  if (stateChanges==0)
  {
    println("Steady state found");
    noLoop();
  }
  if(iteration==6)
  {
    noLoop();
  }
  iteration++;
}

int countNearCubes(int[][][] currentState, int x, int y,int z)
{
  int nearCubes=0;
  int checkXStart, checkXEnd;
  int checkYStart, checkYEnd;
  int checkZStart, checkZEnd;
  int xc=0,yc=0,zc=0;
  
  // check neighbour seats - safely, considering array edge cases
  checkXStart=x-1;
  if (checkXStart<0)
  {
    checkXStart=0;
  }
  
  checkXEnd=x+1;
  if (checkXEnd>=xd)
  {
    checkXEnd=xd-1;
  }
  
  checkYStart=y-1;
  if (checkYStart<0)
  {
    checkYStart=0;
  }
  
  checkYEnd=y+1;
  if (checkYEnd>=yd)
  {
    checkYEnd=yd-1;
  }
  
  checkZStart=z-1;
  if (checkZStart<0)
  {
    checkZStart=0;
  }
  
  checkZEnd=z+1;
  if (checkZEnd>=yd)
  {
    checkZEnd=yd-1;
  }

  int cubesChecked=0;

  for (xc=checkXStart;xc<=checkXEnd;xc++)
  {
    for (yc=checkYStart;yc<=checkYEnd;yc++)
    {
      for (zc=checkZStart;zc<=checkZEnd;zc++)
      {
  
        //print(xc+","+yc+" ");
        cubesChecked++;
        if (xc==x && yc==y && zc==z)
        {
          // skip the cell itself
        }
        else
        {
          // check if neighbours are full or not
          if (currentState[xc][yc][zc]>0)
          {
            nearCubes++;
          }
        }
      }
    }
  }
  //print("Seats checked="+cubesChecked+" "+nearCubes);
  return(nearCubes);
}
