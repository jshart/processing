int maxW=1200;
int maxH=600;

ArrayList<VorNode> vorNodes = new ArrayList<VorNode>();

void setup()
{
  size(1200,600);
  background(255,255,255);  
  
  int i;
  int maxNodes=100;
  
  for(i=0;i<maxNodes;i++)
  {
    vorNodes.add(new VorNode(floor(random(0,maxW)),floor(random(0,maxH))));
    //vorNodes.add(new VorNode(floor(map(noise(i),0,1,0,maxW)),floor(map(noise(i),0,1,0,maxH))));

  }
  for(i=0;i<maxNodes;i++)
  {
    vorNodes.get(i).nearest(vorNodes);
  }
}

void draw()
{
  int s=vorNodes.size();
  int i;
  
  for(i=0;i<s;i++)
  {
    vorNodes.get(i).draw();
  }
  noLoop();
}

public class VorNode
{
  int originX;
  int originY;
  color c;
  int tempD; // used to temporarily track distances whilst calculating K nearest, left in garbage state
  int maxNeighbours=10;
  ArrayList<VorNode> kNearest = new ArrayList<VorNode>();
  
  public String toString()
  {
     return("["+originX+":"+originY+"]");
  }
  public VorNode(int x, int y)
  {
    originX=x;
    originY=y;
    
    //c = color(random(0,255),random(0,255),random(0,255),100);
    c = color(100,100,100,200);

  }
  
  public boolean equals(VorNode v)
  {
    if (v.originX == originX && v.originY == originY)
    {
      return(true);
    }
    return(false);
  }
  
  void draw()
  {
    fill(c);
    stroke(c);
    ellipse(originX,originY,10,10);
    
    int i;
    int s=kNearest.size();
    VorNode v;
    
    for (i=0;i<s;i++)
    {
      v=kNearest.get(i);
      line(originX,originY,v.originX,v.originY);
      //print(".");
    }
    int r=averageNeighbourDistance();
    ellipse(originX,originY,r,r);
  }
  
  int averageNeighbourDistance()
  {
    int i;
    int s=kNearest.size();
    VorNode v;
    int total=0;
    
    for (i=0;i<s;i++)
    {
      v=kNearest.get(i);
      total+=v.dist(this);
    }
    return(total/s);
  }
  
  int maxNeighbourDistance()
  {
    int i;
    int s=kNearest.size();
    VorNode v;
    int max=0;
    int d=0;
    
    for (i=0;i<s;i++)
    {
      v=kNearest.get(i);
      d=v.dist(this);
      max=(d>max?d:max);
    }
    return(max);
  }
  
  int minNeighbourDistance()
  {
    int i;
    int s=kNearest.size();
    VorNode v;
    int min=0;

    int d=0;
    
    for (i=0;i<s;i++)
    {
      v=kNearest.get(i);
      d=v.dist(this);
      min=(i==0?d:min); // initialise to a sane value on first pass
      min=(d<min?d:min);
    }
    return(min);
  }
  
  int dist(VorNode v)
  {
    return(dist(v.originX, v.originY));
  }
  
  int dist(int x, int y)
  {
    float d;
    int xd = abs(x-originX);
    int yd = abs(y-originY);
    d=sqrt((xd*xd)+(yd*yd));
    
    return(floor(d));
  }
  
  void nearest(ArrayList<VorNode> neighbours)
  {
    int s=neighbours.size();
    int ks;
    int i;
    int k;
    int maxD=0;
    int maxDIndex=0;
    VorNode v;
    
    // Check every node in the complete set
    for (i=0;i<s;i++)
    {
      v=neighbours.get(i);
      v.tempD=dist(v);
      
      // If this node, is this node, then we're uninterested in considering it
      // as a nearest neighbour (as its the same node), so skip it.
      if (v.equals(this))
      {
        continue;
      }
      
      // have we filled the list yet? if not then we always add
      ks = kNearest.size();
      if (ks<maxNeighbours)
      {
        kNearest.add(v);
        
        // Is this the furthest item so far? if so keep a note of it
        // as we will likely over-ride it in the future.
        if (v.tempD>maxD)
        {
          // note that Ks is the *size* of the array, which happens to
          // become the index of the last item when we add an element,
          // so we're using it as a short cut here to determine the
          // index of the element we just added
          maxDIndex=ks;
          maxD=v.tempD;
        }
      }
      else
      {
        // we've filled the list, only add the new connection if it
        // is closer than the previous.
        if (v.tempD<maxD)
        {
          // reset the node as we've found a closer
          kNearest.set(maxDIndex,v);
          
          // Now search for a new maximum neighbour distance in the current nearest set
          ks = kNearest.size();
          for (k=0;k<ks;k++)
          {
            v=kNearest.get(k);
            
            // Initialise the max distance to the first node, if any node is further
            // it will over-ride this in future iterations
            if (k==0)
            {
              maxD=v.tempD;
              maxDIndex=0;
            }
            else
            {
              if (v.tempD>maxD)
              {
                maxD=v.tempD;
                maxDIndex=k;
              }
            }
          }
        }
      }
    }   
    //println(this+":"+kNearest.get(0)+":"+kNearest.get(1)+":"+kNearest.get(2));
  }
}
