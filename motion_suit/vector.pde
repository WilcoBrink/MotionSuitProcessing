class Vector { 
  float xpos, ypos, zpos; 
  Vector (float xpos, float ypos, float zpos) {  
    this.xpos = xpos; 
    this.ypos = ypos;
    this.zpos = zpos; 
  }
  float lengte()
  {
   float lengte = sqrt(sq(xpos)+sq(ypos)+sq(zpos));
  return lengte; 
    
  }
  void update(float xpos,float ypos, float zpos)
  {
    this.xpos = xpos; 
    this.ypos = ypos;
    this.zpos = zpos; 
  }
}


