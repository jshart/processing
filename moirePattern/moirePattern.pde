void setup()
{
  size(640,640);
}

void draw()
{
  int i;
  for (i=0;i<640;i+=4)
  {
    line (0,i,640-i,0);
    line (640,640-i,i,640);
  }
}
