int maxW=1200;
int maxH=600;

ArrayList<VorNode> vorNodes = new ArrayList<VorNode>();
ArrayList<Cluster> clusters = new ArrayList<Cluster>();

int maxNodes=500;
int maxClusters=20;

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

int noIterations=0;
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
  boolean stillImproving=false;
  for(i=0;i<cs;i++)
  {
    clusters.get(i).draw();
    if (clusters.get(i).resetCluster()==true)
    {
      stillImproving=true;
    }
  }
  
  // calculate new cluster memberships
  for(i=0;i<vs;i++)
  {
    // for each node check each cluster to find best match
    vorNodes.get(i).findClusterCentroid(clusters);
  }
  
  delay(1250);
  println("*** Iteration ==="+noIterations++);
  
  // If we're no longer improving, stop looping...
  if (stillImproving==false)
  {
    println("+++ Converged on best fit after "+noIterations+" iterations");
    noLoop();
  }
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
    int currentBestDist=0;
    Cluster tempC=null;
    
    // Check each cluster to see if this is a best match?
    for (i=0;i<cs;i++)
    {
      // Fetch cluster and check distance to it.
      tempC=clusters.get(i);
      d=dist(tempC);
      
      //bestD=(i==0?d:bestD);
      // initialise to a sane value on first pass, assume this
      // is the best match until we know better.
      if (i==0)
      {
        currentBestDist=d;
        clusterCentroid=tempC;
      }
      else
      {
        // for subsequent matches, check to see if the new
        // distance is better than our current one.
        //currentBestDist=(d<currentBestDist?d:currentBestDist);
        if (d<currentBestDist)
        {
          currentBestDist=d;
          clusterCentroid=tempC;
        }        
      }  
    }
    
    if (clusterCentroid!=null)
    {
      clusterCentroid.memberNodes.add(this);
    }
  }
}

public class Cluster
{
  int centroidX;
  int centroidY;
  color c=color(0,0,0);
  color areaC=color(random(0,255),0,0,50);

  ArrayList<VorNode> memberNodes = new ArrayList<VorNode>();

  int minX=0, maxX=0, minY=0, maxY=0;
  
  public Cluster(int x, int y)
  {
    centroidX=x;
    centroidY=y;
    //c=color(0,0,0);
  }
  
  void draw()
  {
    fill(c);
    stroke(c);
    ellipse(centroidX,centroidY,10,10);
    
    int xd=maxX-minX;
    int yd=maxY-minY;
    
    fill(areaC);
    stroke(areaC);
    //fill(100,100,100,50);
    ellipse(centroidX,centroidY,xd,yd);
    println("E:"+xd+","+yd+" X:"+minX+","+maxX+" Y:"+minY+","+maxY);
  }
  
  // Refine the new centroid position and then
  // Nuke the member list ready for next iteration
  // TODO - somewhere in here or refineCentroid, i need
  // a way of determining if the cluster has stablised.
  boolean resetCluster()
  {
    int oldcX=centroidX;
    int oldcY=centroidY;
    refineCentroid();
    memberNodes.clear();
    
    // check if we've successfully refined - if the centroid
    // didnt move, then then we're done, if it did move
    // then we managed to do some refinement.
    if (oldcX==centroidX && oldcY==centroidY)
    {
      return(false);
    }
    return(true);
  }
  
  void refineCentroid()
  {
    int i;
    int ms=memberNodes.size();
    
    minX=centroidX;
    maxX=centroidX;
    minY=centroidY;
    maxY=centroidY;
    
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
      /*if (i==0)
      {
        minX=v.originX;
        maxX=v.originX;
        minY=v.originY;
        maxY=v.originY;
      }*/
      minX=(v.originX<minX?v.originX:minX);
      maxX=(v.originX>maxX?v.originX:maxX);
      minY=(v.originY<minY?v.originY:minY);
      maxY=(v.originY>maxY?v.originY:maxY);
      
      averageX+=v.originX;
      averageY+=v.originY;
    }
    
    centroidX=averageX/ms;
    centroidY=averageY/ms;
    
    println("C:"+centroidX+","+centroidY+" MS:"+ms);
    /*minX=(centroidX<minX?centroidX:minX);
    maxX=(centroidX>maxX?centroidX:maxX);
    minY=(centroidY<minY?centroidY:minY);
    maxY=(centroidY>maxY?centroidY:maxY);*/
  }
}
