PVector origin = new PVector(0, 0);
PVector path1 = new PVector(random(200), random(200));
PVector path2 = new PVector(random(400), random(400));

int segments=10;
PVector[] path;

public void setup() {
  size(500, 500);

  path = new PVector[segments];

  int i;
  for (i=0; i<segments; i++)
  {
    path[i]=new PVector(50*i, 250+(random(200)-100));
  }
}

public void draw() {
  stroke(255, 0, 0);
  int j, i;



  for (j=0; j<segments-2; j++)
  {
    PVector start, end, middle;
    float m1 =path[j].mag();
    float m2 =path[j+1].mag();

    float steps = m2>m1?m2:m1;

    for (i=0; i<(steps/2); i++)
    {
      start = PVector.lerp(path[j], path[j+1], ((1/steps)*i)+0.5);
      end = PVector.lerp(path[j+1], path[j+2], ((1/steps)*i)+0.5);

      middle = PVector.lerp(start, end, (1/steps)*i);
      
      //stroke(0, 0, 255);
      //line(start.x,start.y,end.x,end.y);
      
      stroke(0, 255, 0);
      ellipse(middle.x, middle.y, 1, 1);

      //print(start);
    }
  }
  
  stroke(255, 0, 0);
  for (j=0; j<segments-1; j++)
  {
    line(path[j].x, path[j].y, path[j+1].x, path[j+1].y);
  }
}
