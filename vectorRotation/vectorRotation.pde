PVector v =  PVector.random2D();
//PVector v =  new PVector(100,100);
PVector n;

PVector uBound;
PVector lBound;

void setup()
{
  size(640,640);
  v.mult(100);
  n=v.copy();
  
  print("H:"+v.heading()+" M"+v.mag());
  print(v);
  
  n.rotate(random(HALF_PI)-QUARTER_PI);
  n.add(v);
  
  uBound=v.copy();
  uBound.rotate(-QUARTER_PI);
  uBound.add(v);
  lBound=v.copy();
  lBound.rotate(QUARTER_PI);
  lBound.add(v);
  println();
  print("V:"+v+" M:"+v.mag());
  println();
  print("N:"+n+" M:"+n.mag());
}

void draw()
{
    
  translate(320,320);

  stroke(0,255,0);
  line(0,0,v.x,v.y);
  line(v.x,v.y,n.x,n.y);
  stroke(255,0,0);
  line(v.x,v.y,uBound.x,uBound.y);
  line(v.x,v.y,lBound.x,lBound.y);
}
