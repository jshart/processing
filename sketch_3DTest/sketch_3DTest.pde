float x,y,z;
SolarSystem system = new SolarSystem();

void setup()
{
  //size(600,600,P3D);
  size(800,800);
  
  x=width/2;
  y=height/2;
  z=0;
}

void draw()
{
  background(10);

  //translate(x, y, -200);
  translate(x, y);

  system.update();
  system.draw();
  
  
 /* 
  pushMatrix();
  fill(192,192,192);
  rotateX(angle);
  translate(0,300,0);
  rotateZ(angle);
  rotateY(angle);
  rectMode(CENTER);
  rect(0,0,100,100);
  popMatrix();*/

  //z++;
}
