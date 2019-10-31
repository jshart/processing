int maxW=1200;
int maxH=600;

ArrayList<VorNode> vorNodes = new ArrayList<VorNode>();
ArrayList<Cluster> clusters = new ArrayList<Cluster>();

int maxNodes=100;
int maxClusters=10;

void setup()
{
  size(1200,600);
  
  int i;

  // Create some random centroid points...
  for(i=0;i<maxClusters;i++)
  {
    clusters.add(new Cluster(floor(random(0,maxW)),floor(random(0,maxH))));
  }
  
  // Create some random nodes, and then find which clusters they best match
  // and add them to the array
  VorNode v;
  for(i=0;i<maxNodes;i++)
  {
    v=new VorNode(floor(random(0,maxW)),floor(random(0,maxH)));
    v.findClusterCentroid(clusters);
    vorNodes.add(v);
  }
}

void draw()
{
  int vs=vorNodes.size();
  int i;
  
  background(255,255,255);  

  // Draw all the nodes...
  for(i=0;i<vs;i++)
  {
    vorNodes.get(i).draw();
  }
  
  // draw all the clusters and then refine + reset them
  int cs=clusters.size();
  for(i=0;i<cs;i++)
  {
    clusters.get(i).draw();
    clusters.get(i).resetCluster();
  }
  
  // calculate new cluster memberships
  for(i=0;i<vs;i++)
  {
    vorNodes.get(i).findClusterCentroid(clusters);
  }
  
  delay(250);

}


public class VorNode
{
  int originX;
  int originY;
  color c;
  Cluster clusterCentroid;
  
  public String toString()
  {
     return("["+originX+":"+originY+"]");
  }
  public VorNode(int x, int y)
  {
    originX=x;
    originY=y;
    
    c = color(random(0,255),random(0,255),random(0,255),100);
    //c = color(100,100,100,200);

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
    
    if (clusterCentroid!=null)
    {
      line(originX,originY,clusterCentroid.centroidX, clusterCentroid.centroidY);
    }
  }
  
  int dist(Cluster v)
  {
    return(dist(v.centroidX, v.centroidY));
  }
  
  int dist(int x, int y)
  {
    float d;
    int xd = abs(x-originX);
    int yd = abs(y-originY);
    d=sqrt((xd*xd)+(yd*yd));
    
    return(floor(d));
  }
  
  // Runs through the candidate clusters and determines
  // which one is closest match for this node and then
  // cross-links the node to the cluster
  void findClusterCentroid(ArrayList<Cluster> clusters)
  {
    int cs=clusters.size();
    int i=0;
    int d=0;
    int bestD=0;
    int oldBest=0;
    Cluster tempC;
    
    for (i=0;i<cs;i++)
    {
      tempC=clusters.get(i);
      d=dist(tempC);
      bestD=(i==0?d:bestD); // initialise to a sane value on first pass
      bestD=(d<bestD?d:bestD);
      
      if (oldBest!=bestD)
      {
          clusterCentroid=tempC;

          clusterCentroid.memberNodes.add(this);
      }
      
      oldBest=bestD;
    }
  }
}

public class Cluster
{
  int centroidX;
  int centroidY;
  color c;
  ArrayList<VorNode> memberNodes = new ArrayList<VorNode>();

  
  public Cluster(int x, int y)
  {
    centroidX=x;
    centroidY=y;
    c=color(0,0,0);
  }
  
  void draw()
  {
    fill(c);
    stroke(c);
    ellipse(centroidX,centroidY,10,10);
  }
  
  // Refine the new centroid position and then
  // Nuke the member list ready for next iteration
  // TODO - somewhere in here or refineCentroid, i need
  // a way of determining if the cluster has stablised.
  void resetCluster()
  {
    refineCentroid();
    memberNodes.clear();
  }
  
  void refineCentroid()
  {
    int i;
    int ms=memberNodes.size();
    
    // If this is an empty cluster, then we cant do anything further to
    // refine it, just return and avoid a divide-by-zero
    if (ms==0)
    {
      return;
    }
    
    // Run through all the members and work out a new average X/Y
    int averageX=0;
    int averageY=0;
    VorNode v;
    for (i=0;i<ms;i++)
    {
      v=memberNodes.get(i);
      averageX+=v.originX;
      averageY+=v.originY;
    }
    
    centroidX=averageX/ms;
    centroidY=averageY/ms;
  }
}
